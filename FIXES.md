# Book Match — Prioritized Improvement Plan

Generated: 2026-03-03
Reviewer: Claude Code
Branch: ih-code-review

---

## P0 — Critical (Security / Architecture / Broken Patterns)

These issues must be resolved before the app is considered production-ready.

---

### P0-1: CSRF Protection is Disabled

**File:** `app/controllers/application_controller.rb:4`

**Problem:**
```ruby
skip_forgery_protection
```
This single line disables Rails' Cross-Site Request Forgery (CSRF) protection for every controller in the application. CSRF attacks allow a malicious site to submit forged requests on behalf of a logged-in user. Without CSRF protection, an attacker could trick a user into adding/removing books, changing their password, or deleting their account.

**Suggested solution:**
Remove `skip_forgery_protection` entirely. Rails enables CSRF protection by default via `ActionController::Base`. If forms are failing with `ActionController::InvalidAuthenticityToken`, the fix is to ensure `<%= csrf_meta_tags %>` is in the layout (it already is in `_meta_tags.html.erb`) and that `javascript_importmap_tags` loads the Rails UJS/Turbo token handling.

**Example implementation:**
```ruby
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Remove: skip_forgery_protection

  def pundit_user
    Current.user
  end
  # ...
end
```

---

### P0-2: `UserBookPolicy` References a Non-Existent Attribute

**File:** `app/policies/user_book_policy.rb:3,7,11`

**Problem:**
```ruby
def create?
  record.user_id == user.id  # UserBook has no `user_id` column
end
```
`UserBook` uses `reader_id`, not `user_id`. Every policy check (`create?`, `update?`, `destroy?`) calls `record.user_id`, which returns `nil` and always evaluates to `false`. This means if `authorize` is ever called for `UserBook` operations, it will always deny access — a silent, hard-to-debug failure.

**Suggested solution:**
```ruby
class UserBookPolicy < ApplicationPolicy
  def create?
    record.reader_id == user.id
  end

  def update?
    record.reader_id == user.id
  end

  def destroy?
    record.reader_id == user.id
  end
  # ...
end
```

---

### P0-3: `UserBooksController` Has No `authorize` Calls

**File:** `app/controllers/user_books_controller.rb`

**Problem:**
Pundit is included in `ApplicationController` and policies exist for `UserBook`, but `UserBooksController` never calls `authorize`. The app currently relies on `Current.user.user_books.find_or_initialize_by(...)` for implicit scoping — this prevents cross-user pollution but bypasses the Pundit authorization layer entirely. A future developer adding a route or action would not know authorization is expected.

**Suggested solution:**
Add `authorize` calls, and fix the policy first (see P0-2):
```ruby
# In UserBooksController
def update
  authorize @user_book  # Add this
  respond_to do |format|
    if @user_book.update(user_book_params)
      # ...
    end
  end
end

def destroy
  authorize @user_book  # Add this
  @user_book.destroy!
  # ...
end
```
For `create`, because it's `find_or_initialize_by`, authorization needs care — ensure `@user_book.reader_id == Current.user.id` after initialization before saving.

---

### P0-4: `UserPolicy#show?` Breaks Core App Feature

**File:** `app/policies/user_policy.rb:3`

**Problem:**
```ruby
def show?
  user == record
end
```
This restricts profile viewing to the user themselves. But the core functionality of Book Match — viewing another reader's library to see what books you have in common — requires viewing other users' profiles. If `authorize @user` is ever called on the users show page (it currently isn't), this would block the app's primary value proposition.

**Suggested solution:**
Allow any authenticated user to view any profile (profiles are social by design):
```ruby
def show?
  true  # Any authenticated user can view profiles
end
```
Or if some profile data should be private:
```ruby
def show?
  user.present?  # Must be logged in
end
```

---

## P1 — Important (Maintainability / Convention / Cleanliness)

---

### P1-1: Re-enable Turbo (Currently Globally Disabled)

**File:** `app/javascript/application.js:5`

**Problem:**
```javascript
Turbo.session.drive = false
```
This disables all Turbo Drive navigation for the entire app. Every link click and form submission results in a full page reload. This costs 2 rubric points (AJAX, Turbo Frames) and degrades user experience. The search form also redundantly sets `data: { turbo: false }`.

**Suggested solution:**
Remove the global disable. If specific pages or forms had issues with Turbo that prompted this, fix those individually with `data-turbo="false"` on the specific element:
```javascript
// application.js — remove this line:
// Turbo.session.drive = false
```

Then use Turbo Frames to update just the search results section:
```erb
<!-- In search bar partial -->
<%= turbo_frame_tag "search_results" do %>
  <!-- results here -->
<% end %>
```

---

### P1-2: Fat Controller — Extract `UserBooksController#create` Logic

**File:** `app/controllers/user_books_controller.rb:17–61`

**Problem:**
The `create` action has three branches (~45 lines), manually builds `book_data` from params, calls a service, and handles errors — all in the controller. This violates the "skinny controller" principle.

**Suggested solution:**
Extract the branching logic into the service layer. `BookPersistenceService` could accept either an existing book ID or raw book data:
```ruby
# In UserBooksController#create (simplified)
def create
  result = UserBookCreationService.call(
    user: Current.user,
    book_id: params.dig(:user_book, :book_id),
    book_data: params[:book]&.to_unsafe_h,
    status: user_book_params[:status]
  )

  if result.success?
    redirect_to result.book, notice: "Book added to your library."
  else
    redirect_back fallback_location: books_path, alert: result.error
  end
end
```

---

### P1-3: Duplicate Controller Logic (DRY Violation)

**Files:** `app/controllers/library_controller.rb:4–7`, `app/controllers/users_controller.rb:7–9`

**Problem:**
The reader-loading pattern is copied verbatim in two controllers:
```ruby
@readers = @user.bookmates.exists? ? @user.bookmates : @user.similar_readers
@readers_count = @user.readers_count
```

**Suggested solution:**
The conditional already exists as `readers_count` in the User model. Extract the readers selection to a model method too:
```ruby
# In app/models/user.rb
def primary_readers
  bookmates.exists? ? bookmates : similar_readers
end
```
Then both controllers call `@user.primary_readers` instead of duplicating the ternary.

---

### P1-4: Delete Unused Scaffold-Generated Views

**Files:**
- `app/views/books/edit.html.erb`
- `app/views/books/new.html.erb`
- `app/views/books/_form.html.erb`
- `app/views/user_books/index.html.erb`
- `app/views/user_books/show.html.erb`
- `app/views/user_books/new.html.erb`
- `app/views/user_books/edit.html.erb`
- `app/views/user_books/_user_book.html.erb`
- `app/javascript/controllers/hello_controller.js`

**Problem:**
Routes for books only expose `index`, `show`, and `search`. Routes for user_books only expose `create`, `update`, `destroy`. All the views listed above are unreachable dead code from scaffold generation. `hello_controller.js` is the default Stimulus placeholder and is never registered or used.

**Suggested solution:**
Delete all of these files. They add confusion for future developers and inflate the apparent scope of the codebase.

---

### P1-5: Add `UserBook.status` Validation

**File:** `app/models/user_book.rb`

**Problem:**
`status` is a free-form string with no validation. Values like `"reading"`, `"finished"`, or typos like `"raed"` would be silently saved. The app logic depends on specific values: `"read"` and `"want_to_read"`.

**Suggested solution:**
Use an enum:
```ruby
class UserBook < ApplicationRecord
  enum :status, { read: "read", want_to_read: "want_to_read" }, validate: true

  # Or with a simple inclusion validation:
  validates :status, inclusion: { in: %w[read want_to_read], allow_nil: true }
end
```

---

### P1-6: Fix Bug in `BooksController#search` — Undefined Variable in JSON Response

**File:** `app/controllers/books_controller.rb:31`

**Problem:**
```ruby
format.json { render json: { internal: @search_results, external: @external_results } }
```
`@search_results` is never assigned — the variable is `@internal_results`. The JSON response would always return `null` for `internal`.

**Suggested solution:**
```ruby
format.json { render json: { internal: @internal_results, external: @external_results } }
```

---

### P1-7: Complete or Remove `UsersController#destroy`

**File:** `app/controllers/users_controller.rb:35–37`

**Problem:**
```ruby
def destroy
  # TODO: delete
end
```
Empty action with a TODO comment. This is a broken feature — if a user somehow reaches this route, nothing happens. Either implement account deletion or remove the route and action.

**Suggested solution:**
If implementing account deletion:
```ruby
def destroy
  authorize @user
  @user.destroy!
  redirect_to root_path, notice: "Your account has been deleted."
end
```
If not implementing yet, remove the action and remove `destroy` from the `resources :users` route.

---

### P1-8: Inline Style in Application Layout

**File:** `app/views/layouts/application.html.erb:21`

**Problem:**
```erb
<div class="container-fluid" style="max-width: 1200px; margin: 0 auto; padding: 2rem;">
```
Inline styles in the layout affect every page and should be in a CSS class.

**Suggested solution:**
```erb
<div class="container-fluid app-container">
```
```css
/* In shared.css or application.css */
.app-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}
```

---

### P1-9: Add a Minimal Test Suite

**Files:** `spec/`, `Gemfile`

**Problem:**
The RSpec gems are commented out in Gemfile. The only spec is `expect(1).to eq(1)`. The recommendation algorithm in `User#bookmates`, `User#similar_readers`, and `User#recommended_books` has no test coverage, which makes future changes risky.

**Suggested solution:**
Uncomment the RSpec gems and add model specs:
```ruby
# Gemfile
group :development, :test do
  gem "rspec-rails", "~> 7.1.1"
end

group :test do
  gem "shoulda-matchers", "~> 6.4"
end
```

Priority specs:
```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe "#bookmates" do
    it "returns users with 5 or more books in common"
    it "excludes the current user"
  end

  describe "#recommended_books" do
    it "excludes books already in the user's library"
    it "returns books from similar readers"
  end
end
```

---

### P1-10: `sample_data.rake` Defines Top-Level Constant

**File:** `lib/tasks/sample_data.rake:21–22`

**Problem:**
```ruby
STATUS = [ "read", "want_to_read" ]
RATE = [ 1, 2, 3, 4, 5 ]
```
Top-level constant definitions in rake tasks pollute the global constant namespace and can cause `already initialized constant` warnings when tasks are loaded multiple times.

**Suggested solution:**
Use local variables inside the task block:
```ruby
task({ sample_data: :environment }) do
  statuses = [ "read", "want_to_read" ]
  ratings = [ 1, 2, 3, 4, 5 ]
  # ...
  status: statuses.sample,
  rating: ratings.sample
end
```

---

## P2 — Polish / UX / Enhancements

---

### P2-1: Add ERD and Setup Instructions to README

**File:** `README.md`

**Problem:**
The ERD exists in `functional_spec.md` but the README has no link to it. No credential setup instructions exist. New developers would be blocked.

**Suggested solution:**
Add to README:
```markdown
## Configuration

1. Set up Rails credentials:
   ```
   rails credentials:edit
   ```
   Add the following structure:
   ```yaml
   mailtrap:
     api_key: your_mailtrap_api_key
   ```

2. (Development) Email is handled by letter_opener — no credentials needed locally.

## Entity Relationship Diagram

See [functional_spec.md](functional_spec.md#domain-model) for the full ERD and domain model.
```

---

### P2-2: Add `<main>` Semantic Element to Layout

**File:** `app/views/layouts/application.html.erb`

**Problem:**
The main content area uses a `<div>` instead of `<main>`, which reduces semantic clarity and accessibility.

**Suggested solution:**
```erb
<main class="app-container" role="main">
  <%= render "shared/flash" %>
  <%= yield %>
</main>
```

---

### P2-3: Add Pagination to Search Results and Library

**Files:** `app/controllers/books_controller.rb`, `app/controllers/library_controller.rb`

**Problem:**
`recommended_books` and search results have no pagination. Users with large libraries or popular searches would receive unbounded result sets.

**Suggested solution:**
Add Kaminari: `gem "kaminari"` and paginate results:
```ruby
@recommended_books = Current.user.recommended_books.page(params[:page]).per(20)
```

---

### P2-4: Scope `@book.readers` Query on Book Show Page

**File:** `app/views/books/show.html.erb:102–111`

**Problem:**
```erb
<% @book.readers.where.not(id: Current.user.id).each do |reader| %>
```
A database query is being made directly in the view. This violates separation of concerns.

**Suggested solution:**
Move this to the controller:
```ruby
# In BooksController#show
@other_readers = @book.readers.where.not(id: Current.user.id)
```
And use `@other_readers` in the view.

---

### P2-5: Replace CDN Links with Asset Pipeline

**File:** `app/views/layouts/application.html.erb:17–22`

**Problem:**
Bootstrap and Font Awesome are loaded from CDN. This creates external dependencies, potential privacy concerns, and means the app won't work offline or in air-gapped environments.

**Suggested solution:**
Add Bootstrap and Font Awesome via importmap or npm packages:
```
./bin/importmap pin bootstrap
```
Or use `cssbundling-rails` for CSS frameworks.

---

### P2-6: Add Branch Protection and Require PR Reviews

**GitHub Repository Settings**

**Problem:**
Branch protection cannot be verified from the codebase. If not configured, direct pushes to `main` are allowed and the CI pipeline provides no enforcement gate.

**Suggested solution:**
In GitHub repository settings → Branches → Branch protection rules for `main`:
- Require pull request reviews before merging (1 reviewer)
- Require status checks to pass (all 3 CI jobs)
- Require branches to be up to date before merging
- Restrict direct pushes

---

### P2-7: Add End-to-End Test Plan Document

**File:** New file `TEST_PLAN.md`

**Problem:**
`functional_spec.md` has user stories but no formal test scenarios.

**Suggested solution:**
Create `TEST_PLAN.md` with test scenarios covering:
- User registration and login
- Adding a book from internal search
- Adding a book from Open Library (external search)
- Marking a book as read vs. want-to-read
- Rating a book
- Viewing another user's profile
- Password reset flow
- Recommendation algorithm (verify "For You" tab shows expected books)

---

### P2-8: Resolve Over-Commenting in `modal_controller.js`

**File:** `app/javascript/controllers/modal_controller.js`

**Problem:**
Nearly every line has a comment explaining what the code does rather than why. Example:
```javascript
// Use native dialog close() method
d.close()
```

**Suggested solution:**
Reduce to comments that explain non-obvious decisions. The accessibility focus-management comment is a good example of a useful comment. Comments on `d.close()` or `event.preventDefault()` add no value.

---

### P2-9: Consider Adding OAuth for Sign-In

**Files:** `Gemfile`, `app/controllers/sessions_controller.rb`

**Problem:**
The app uses custom authentication (`has_secure_password`) which works but requires email verification setup and password reset infrastructure. OAuth would reduce friction for new users.

**Suggested solution:**
Rails 8 has built-in OAuth support via the authentication generator. Alternatively, add OmniAuth with GitHub or Google:
```ruby
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
```
This would also count as the "OAuth" ambitious feature worth 2 points on the rubric.
