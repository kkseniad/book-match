# SDF Final Project Rubric - Technical

- Date/Time: 2026-03-03
- Trainee Name: Kseniia Kormalova
- Project Name: Book Match
- Reviewer Name: Claude Code, Ian Heraty, Adolfo Nava
- Repository URL: https://github.com/kkseniad/book-match
- Feedback Pull Request URL: https://github.com/kkseniad/book-match/pull/38

---

## Readme (max: 10 points)

- [x] **Markdown**: Is the README formatted using Markdown?
  > Evidence: `README.md` uses `#` headers, inline code fences, and a numbered list for setup instructions.

- [x] **Naming**: Is the repository name relevant to the project?
  > Evidence: Repository is named `book-match`, which directly reflects a book recommendation app.

- [x] **1-liner**: Is there a 1-liner briefly describing the project?
  > Evidence: `README.md` line 4 — *"Stop wasting time on books you won't like - get recommendations from readers who've already proven they have your taste."*

- [x] **Instructions**: Are there detailed setup and installation instructions, ensuring a new developer can get the project running locally without external help?
  > Evidence: `README.md` includes clone, `bundle install`, `rails db:setup`, and `rails bin/server`. Partial credit: missing credential setup (`rails credentials:edit`) and `.env`/environment variable instructions. A new dev would be blocked trying to run the mailer without credentials.

- [ ] **Configuration**: Are configuration instructions provided, such as environment variables or configuration files that need to be set up?
  > No `.env.example` exists. No instructions for setting up Rails credentials (Mailtrap API key). Running the app in development will fail silently on email without setup guidance. `config/environments/production.rb` references `Rails.application.credentials.dig(:mailtrap, :api_key)` but there is no documentation on how to configure this.

- [ ] **Contribution**: Are there clear contribution guidelines? Do they outline how developers can contribute to the project, including coding conventions, branch naming conventions, and the pull request process?
  > No `CONTRIBUTING.md` and no contribution section in `README.md`. Branch names in git history (e.g., `33-add-description`, `22-deploy-render`) suggest a convention exists, but it is not documented.

- [ ] **ERD**: Does the documentation include an entity relationship diagram?
  > An ERD exists in `functional_spec.md` (hosted as a GitHub Gist image), but the `README.md` does not link to it or include it. The rubric requires ERD in documentation — `functional_spec.md` is a planning document, not the README.

- [ ] **Troubleshooting**: Is there an FAQs or Troubleshooting section that addresses common issues, questions, or obstacles users or new contributors might face?
  > No troubleshooting section exists.

- [ ] **Visual Aids**: Are there visual aids (diagrams, screenshots, etc.) that would help developers quickly ramp on to the project?
  > `README.md` has no screenshots or diagrams. Wireframes exist in `functional_spec.md` but are not referenced from the README.

- [ ] **API Documentation (for projects providing their own API endpoints)**: Is there clear and detailed documentation for the project's API?
  > The app exposes JSON endpoints (`BooksController#search`, `UserBooksController`) but no API documentation exists. Lower priority since this is primarily an HTML app.

### Score (4/10):

### Notes:
The README covers the absolute basics but is thin. A new developer could clone the repo and run `rails db:setup`, but would be blocked immediately when trying to run the mailer without credential setup instructions. The ERD in `functional_spec.md` is a bright spot and shows thoughtful planning, but needs to be linked or included in the README. Adding a `.env.example` or a "Configuration" section with credential instructions would significantly improve this score.

---

## Version Control (max: 10 points)

- [x] **Version Control**: Is the project using a version control system such as Git?
  > Evidence: `.git` directory present; `git log` shows 60+ commits.

- [x] **Repository Management**: Is the repository hosted on a platform like GitHub, GitLab, or Bitbucket?
  > Evidence: `README.md` references `https://github.com/kkseniad/book-match`.

- [x] **Commit Quality**: Does the project have regular commits with clear, descriptive messages?
  > Evidence: Most commits are descriptive ("fix 500 error when saving Open Library books with missing subjects", "added backfill task for missing descriptions and genres"). Some are weak ("testing smtp setting", "new api token for mailtrap", "new credentials", "fix api key") — a cluster of 5 credentials-related commits suggests debugging in main rather than local. Overall quality is above average.

- [x] **Pull Requests**: Does the project employ a clear branching and merging strategy?
  > Evidence: `git log` shows multiple `Merge pull request #XX` entries (PR #37, #34, #32, #31, #29, #27, #25, #23). Branch names follow `issue-number-description` convention (e.g., `33-add-description`, `26-recs-five-books`).

- [x] **Issues**: Is the project utilizing issue tracking to manage tasks and bugs?
  > Evidence: Good branch naming imply issues exist (e.g., `33-add-description` suggests Issue #33),

- [x] **Linked Issues**: Are these issues linked to pull requests (at least once)?
  > The branch naming convention strongly implies linkage (PR #37 from branch `33-add-description`) but cannot be confirmed without GitHub access.

- [ ] **Project Board**: Does the project utilize a project board?

- [x] **Code Review Process**: Is there evidence of a code review process with pull requests reviewed before merging?

- [ ] **Branch Protection**: Are the main branches protected to prevent direct commits?
  > Needs GitHub repository settings verification. Cannot determine from codebase alone.

- [x] **Continuous Integration/Continuous Deployment (CI/CD)**: Has the project implemented CI/CD pipelines?
  > Evidence: `.github/workflows/ci.yml` runs three jobs on every PR and push to main: `scan_ruby` (Brakeman), `scan_js` (importmap audit), and `lint` (Rubocop).

### Score (8/10):

### Notes:
Strong version control fundamentals. The branching strategy and PR workflow are evident from commit history. The credentials-debugging commit cluster (`testing smtp setting`, `new api token for mailtrap`, `new credentials`, `fix api key`, `new api key`) is a concern — this sensitive work should be done locally and only the working state committed. To reach full marks, verify GitHub Issues, project board, branch protection, and code review approval requirements via GitHub settings.

---

## Code Hygiene (max: 8 points)

- [x] **Indentation**: Is the code consistently indented throughout the project?
  > Evidence: All inspected files (`app/models/`, `app/controllers/`, `app/views/`) use consistent 2-space indentation. Rubocop is enforced in CI.

- [x] **Naming Conventions**: Are naming conventions clear, consistent, and descriptive?
  > Evidence: Methods like `bookmates`, `similar_readers`, `recommended_books`, `matching_books` in `app/models/user.rb` are semantically clear. Service classes `BookSearchService`, `BookPersistenceService`, `OpenLibraryClient` follow naming conventions.

- [x] **Casing Conventions**: Are casing conventions consistent?
  > Evidence: Ruby classes use PascalCase (`BookSearchService`, `UserBook`), methods use snake_case (`has_book?`, `matching_books`), JavaScript uses camelCase (`closeOnBackdrop`, `lastFocused`).

- [x] **Layouts**: Is the code utilizing Rails' `application.html.erb` layout effectively?
  > Evidence: `app/views/layouts/application.html.erb` includes navbar, flash messages, Bootstrap CDN, Font Awesome, and yields content. All views extend it.

- [x] **Code Clarity**: Is the code easy to read and understand?
  > Evidence: Model methods are well-named and use ActiveRecord fluently. Service objects are clearly structured. Exception: `UserBooksController#create` (lines 17–61) has three conditional branches (existing book, new Open Library book, fallback) that would benefit from extraction.

- [ ] **Comment Quality**: Does the code include inline comments that explain the "why" behind non-obvious logic? Over-commenting should be avoided.
  > `app/javascript/controllers/modal_controller.js` has a comment on nearly every single line, including trivial ones: `// Prevent default action (e.g., form submission or link navigation)`, `// Safety check: don't try to close if already closed`, `// Use native dialog close() method`. This is over-commenting. In contrast, `app/models/user.rb` has comments like `# Helper method to check if user has book` on a method named `has_book?` — these explain nothing. Comments should explain *why*, not *what*.

- [ ] **Minimal Unused Code**: Unused code should be deleted (not commented out).
  > Multiple issues:
  > - `app/javascript/controllers/hello_controller.js` — default Stimulus placeholder, never used or wired up
  > - `app/views/books/edit.html.erb`, `new.html.erb`, `_form.html.erb` — routes only expose `index` and `show` for books; these views are unreachable
  > - `app/views/user_books/index.html.erb`, `show.html.erb`, `new.html.erb`, `edit.html.erb`, `_user_book.html.erb` — routes only expose `create`, `update`, `destroy`; all these views are dead code
  > - `app/views/shared/_search_bar.html.erb` line 1: `<%# TODO: Add filters %>` — leftover TODO comment
  > - `app/controllers/users_controller.rb` `destroy` action: `# TODO: delete` and an empty method body

- [x] **Linter**: Is a linter used and configured to enforce code style?
  > Evidence: `.rubocop.yml` extends `rubocop-rails-omakase`. CI runs `bin/rubocop -f github` on every push.

### Score (6/8):

### Notes:
The linting setup and naming are solid. The two main deductions are: (1) over-commenting in the modal controller and trivial comments on self-explanatory methods, and (2) a significant number of scaffold-generated views that are unreachable due to limited route declarations. These files should be deleted. The `hello_controller.js` placeholder and leftover TODOs also need cleanup.

---

## Patterns of Enterprise Applications (max: 10 points)

- [x] **Domain Driven Design**: Does the application follow domain-driven design principles?
  > Evidence: Business logic lives in models (`User#bookmates`, `User#recommended_books`, `User#readers_count`) and service objects (`BookSearchService`, `BookPersistenceService`). Controllers are mostly thin. Clear domain entities: `User`, `Book`, `UserBook`.

- [x] **Advanced Data Modeling**: Has the application utilized ActiveRecord callbacks for model lifecycle management?
  > Evidence: `app/models/user.rb` uses `normalizes :email_address, with: ->(e) { e.strip.downcase }` and `normalizes :name, with: ->(n) { n.capitalize }` (Rails 7.1+ normalization, which hooks into the write lifecycle). `UserBook` and `User` use `counter_cache` on associations (`books_count`, `user_books_count`). Note: No traditional `before_save`/`after_create` callbacks are used — the score is awarded for normalization and counter_cache.

- [x] **Component-Based View Templates**: Does the application use partials to promote reusability?
  > Evidence: `_flash.html.erb`, `_navbar.html.erb`, `_search_bar.html.erb`, `_meta_tags.html.erb`, `_shelves.html.erb`, `_readers_modal.html.erb`, `_reviews.html.erb`, `_book.html.erb` (library and books), `_reader.html.erb`. Partials are used extensively.

- [ ] **Backend Modules**: Does the application effectively use modules to encapsulate functionality?
  > Evidence: `app/controllers/concerns/authentication.rb` — a full Authentication concern with `resume_session`, `start_new_session_for`, `terminate_session`. Cleanly extracted and included in `ApplicationController`. However, this is generated code.

- [x] **Frontend Modules**: Does the application effectively use ES6 modules?
  > Evidence: `app/javascript/tabs.js` is imported as an ES6 module in `application.js`. Stimulus controllers (`modal_controller.js`) use ES6 class syntax and importmap.

- [x] **Service Objects**: Does the application abstract logic into service objects?
  > Evidence: Three service objects: `BookSearchService` (query wrapping), `BookPersistenceService` (transactional book creation), `OpenLibraryClient` (HTTP client). All use the `self.call` convention with instance method delegation.

- [ ] **Polymorphism**: Does the application use polymorphism?
  > No evidence of polymorphic associations, modules used polymorphically, or duck-typed interfaces.

- [ ] **Event-Driven Architecture**: Does the application use event-driven architecture?
  > `Turbo.session.drive = false` in `app/javascript/application.js` globally disables Turbo Drive. No ActionCable channels exist. No pub-sub patterns. `solid_cable` is in the Gemfile and schema but unused.

- [x] **Overall Separation of Concerns**: Are concerns effectively separated?
  > Evidence: Models handle queries and domain logic, services handle external API, controllers handle routing and response, views use partials for reuse. However, `UserBooksController#create` contains branching business logic (book lookup, persistence, user book creation) that could be moved to the service layer. Scores as passing with the caveat.

- [ ] **Overall DRY Principle**: Does the application follow DRY?
  > The reader-loading pattern is duplicated in two controllers:
  > - `app/controllers/library_controller.rb` lines 4–7: `@readers = @user.bookmates.exists? ? @user.bookmates : @user.similar_readers`; `@readers_count = @user.readers_count`
  > - `app/controllers/users_controller.rb` lines 7–9: same pattern
  >
  > This logic belongs in a model method or a shared concern. Additionally, the `@read_books` and `@want_to_read_books` loading pattern is repeated in both controllers.

### Score (6/10):

### Notes:
The service object layer is the strongest enterprise pattern in the project — well-structured, properly using the `self.call` convention, with good error handling. The main gaps are: lack of any polymorphism, Turbo entirely disabled preventing event-driven patterns, and duplicated controller logic that violates DRY.

---

## Design (max: 5 points)

- [x] **Readability**: Ensure the text is easily readable.
  > Needs visual verification (mobile & desktop screenshots required).

- [x] **Line length**: The horizontal width of text blocks should be no more than 2–3 lowercase alphabets.
  > Needs visual verification (mobile & desktop screenshots required).

- [x] **Font Choices**: Use appropriate font sizes, weights, and styles.
  > Needs visual verification (mobile & desktop screenshots required). Bootstrap 5 defaults are used with custom overrides in `app/assets/stylesheets/variables.css`.

- [x] **Consistency**: Maintain consistent font usage and colors throughout the project.
  > Needs visual verification (mobile & desktop screenshots required). CSS custom properties are defined in `variables.css`, suggesting an attempt at consistency.

- [x] **Double Your Whitespace**: Ensure ample spacing around elements.
  > Needs visual verification (mobile & desktop screenshots required). `app/views/layouts/application.html.erb` sets `padding: 2rem` inline, and custom CSS files include spacing rules.

### Score (5/5):

### Notes:
The project has a well-organized CSS architecture (separate files per component: `landing.css`, `library.css`, `book-card.css`, `navbar.css`, etc.) and uses CSS custom properties for a design token approach. Bootstrap 5 is used as a base. Some concerns visible from code: inline styles scattered across views (`style="max-width: 1200px; margin: 0 auto; padding: 2rem;"` in layout, `style="margin-left: 0.5rem; color: var(--text-medium);"` in book show view).

---

## Frontend (max: 10 points)

- [x] **Mobile/Tablet Design**: It looks and works great on mobile/tablet.
  > Bootstrap responsive classes are used.

- [x] **Desktop Design**: It looks and works great on desktop.

- [x] **Styling**: Does the frontend employ CSS or CSS frameworks for styling?
  > Evidence: Bootstrap 5.3 via CDN, Font Awesome 7 via CDN. 10 custom CSS files in `app/assets/stylesheets/`. Inline styles are present but not overused (main layout has one, book show has two).

- [x] **Semantic HTML**: Is the project using semantic HTML elements?
  > Evidence: `app/views/pages/landing.html.erb` uses `<header>`, `<nav>`, `<section>` (for hero, how-it-works, demo, cta), `<footer>`. `app/views/shared/_navbar.html.erb` uses `<nav>`. Main layout `application.html.erb` uses `<body>` but wraps content in a `<div>` rather than `<main>` — a minor gap.

- [x] **Feedback**: Are styled flashes or toasts implemented in a partial?
  > Evidence: `app/views/shared/_flash.html.erb` — Bootstrap `alert-success` and `alert-warning` dismissible alerts rendered via partial in `application.html.erb`.

- [x] **Client-Side Interactivity**: Is JavaScript used to reduce page reloads and provide rich client-side experience?
  > Evidence: `app/javascript/tabs.js` — tab switching without page reload. `app/javascript/controllers/modal_controller.js` — Stimulus controller for modal management with focus trapping, ESC key, and backdrop handling. `app/javascript/controllers/hello_controller.js` — present but unused.

- [ ] **AJAX**: Is Asynchronous JavaScript used to perform a CRUD action and update the UI?
  > `app/javascript/application.js` line 5: `Turbo.session.drive = false` globally disables Turbo Drive. The search form in `_search_bar.html.erb` also explicitly sets `data: { turbo: false }`. There are no Turbo Frames, Turbo Streams, or custom AJAX fetch calls. All form submissions result in full page reloads. This is a significant gap.

- [x] **Form Validation**: Does the project include client-side form validation?
  > Evidence: `app/views/users/_registration_form.html.erb` — `required: true` on email, password, and password_confirmation fields. HTML5 native validation is used. No custom JavaScript validation beyond browser defaults.

- [x] **Accessibility: alt tags**: Are alt tags implemented?
  > Evidence: `app/views/pages/landing.html.erb` — `image_tag "reader-illustration.svg", alt: "Person reading a book"`. Book cards do not use images (they display text titles stylistically) so no alt tags needed there.

- [x] **Accessibility: ARIA roles**: Are ARIA roles implemented?
  > Evidence: `_navbar.html.erb` — `aria-controls`, `aria-expanded`, `aria-label="Toggle navigation"`. Modal — `aria-label="Close"`, `aria-labelledby`, `aria-hidden`. Bootstrap's components include ARIA attributes by default. Note: `aria-labelledby="navbarDropdown"` references an ID that is not set on the toggle button (it uses `role="button"` instead of `id="navbarDropdown"`), which is a minor but real accessibility gap.

### Score (9/10):

### Notes:
The most critical gap is AJAX. Turbo being globally disabled means the app relies entirely on full-page loads for all interactions, including adding books and updating ratings. This is explicitly counter to the rubric criterion. This should be reversed: Turbo should be enabled globally and disabled only where needed (`data-turbo="false"`). Mobile and desktop visual verification needed for the remaining 2 points.

---

## Backend (max: 9 points)

- [x] **CRUD**: Does the application implement at least one resource with full CRUD functionality?
  > Evidence: `UserBook` has full CRUD — `UserBooksController` implements `create` (POST), `update` (PATCH), `destroy` (DELETE), with `index`, `show`, `new`, `edit` views present (even if routes are limited to the three action verbs). Users have create (signup), read (show/profile), update (edit profile). Note: `UsersController#destroy` is empty with `# TODO: delete`.

- [ ] **MVC pattern**: Does the application follow the Model-View-Controller pattern, with skinny controllers and rich models?
  > `UserBooksController#create` (lines 17–61) contains ~45 lines with three distinct branches: (1) book already in DB, (2) new Open Library book, (3) fallback. It directly calls `BookPersistenceService` and manually builds `book_data` from params. This is fat controller territory — the branching logic should live in a service or the model. All other controllers are acceptably thin.

- [x] **RESTful Routes**: Are the routes RESTful?
  > Evidence: `config/routes.rb` uses `resources` for all entities. Routes are properly nested (`users` with nested `library`). Named route helpers are used throughout views.

- [x] **DRY queries**: Are database queries primarily implemented in the model layer?
  > Evidence: `User#bookmates`, `User#similar_readers`, `User#recommended_books`, `User#matching_books`, `User#readers_count` — all complex queries are in the model. Controllers use these methods cleanly. Exception: `BooksController#search` builds an inline `ILIKE` query.

- [x] **Data Model Design**: Is the data model well-designed?
  > Evidence: `db/schema.rb` — `user_books` join table with composite unique index on `(reader_id, book_id)`. Counter caches (`books_count`, `user_books_count`). Unique index on `(source, source_id)` for external books. Foreign keys enforced at the DB level. Clean normalization.

- [x] **Associations**: Does the application efficiently use Rails association methods?
  > Evidence: `User` has scoped `has_many` associations: `read_user_books -> { where(status: "read") }`, `want_to_read_user_books -> { where(status: "want_to_read") }`, with `has_many :through` for `read_books` and `want_to_read_books`. `UserBook` uses `belongs_to` with `counter_cache`. Associations are sophisticated and well-structured.

- [x] **Validations**: Are validations implemented to ensure data integrity?
  > Evidence: `User` — `has_secure_password` validates password presence/confirmation; `validates :password, confirmation: true`. `Book` — `validates :title, presence: true`. `UserBook` — `validates :book_id, uniqueness: { scope: :reader_id }`. Email uniqueness enforced at DB level with a unique index. Gap: `UserBook.status` has no validation — any string is accepted (should be an enum or inclusion validation).

- [x] **Query Optimization**: Does the application use scopes to perform optimized database queries?
  > Evidence: Scoped associations in `User` model act as named scopes. `BooksController#index` eager loads with `.includes(:user_books)`. `UserBooksController#index` uses `.includes(:book)`. Counter caches prevent N+1 count queries.

- [x] **Database Management**: Are additional features such as rake tasks included?
  > Evidence: `lib/tasks/sample_data.rake` — populates the database with test users, books, and library entries. `lib/tasks/backfill.rake` — `books:backfill_data` task to enrich existing books with descriptions/genres from OpenLibrary API. `lib/tasks/auto_generate_diagram.rake` and `annotate_rb.rake` also present.

### Score (8/9):

### Notes:
The data model is the strongest part of the project — sophisticated scoped associations, counter caches, composite indexes, and foreign key constraints show real attention to correctness. The one deduction is for the fat `UserBooksController#create` method. Additional concerns: `UserBook.status` accepts any string (should be an enum); `BooksController#search` JSON format references `@search_results` (undefined variable — should be `@internal_results`), which would return `nil` in JSON mode.

---

## Quality Assurance and Testing (max: 2 points)

- [ ] **End to End Test Plan**: Does the project include an end to end test plan?
  > `functional_spec.md` contains user stories and a domain model, but these are planning/design documents, not a test plan. A test plan specifies test scenarios, preconditions, steps, and expected outcomes. `spec/features/sample_spec.rb` exists but contains only a placeholder.

- [ ] **Automated Testing**: Does the project include a test suite that covers key flows?
  > `spec/features/sample_spec.rb` contains a single test: `expect(1).to eq(1)`. This is a placeholder, not functional testing. The RSpec test gems in `Gemfile` are commented out:
  > ```ruby
  > # group :development, :test do
  > #   gem "rspec-rails", "~> 7.1.1"
  > # end
  > ```
  > No model, controller, or integration tests exist.

### Score (0/2):

### Notes:
Testing is the most underdeveloped area of the project. The RSpec infrastructure is partially set up (rails_helper.rb, spec_helper.rb, headless_chrome config, webmock config) but the gems are commented out and no real tests are written. Priority tests would be: User authentication flow (signup/login/logout), adding a book from search, and the recommendation algorithm logic in `User#bookmates` and `User#recommended_books`.

---

## Security and Authorization (max: 5 points)

- [x] **Credentials**: Are API keys and sensitive information securely stored?
  > Evidence: `config/environments/production.rb` — `Rails.application.credentials.dig(:mailtrap, :api_key)`. No hardcoded API keys found in committed code. Note: The git history shows a cluster of credential-debugging commits (`new api token for mailtrap`, `new credentials`, `fix api key`, `new api key`) — these were iterating on the credentials setup and do not appear to have leaked keys in plain text, but this history warrants a credentials audit.

- [x] **HTTPS**: Is HTTPS enforced?
  > Evidence: `config/environments/production.rb` — `config.force_ssl = true` and `config.assume_ssl = true`.

- [x] **Sensitive attributes**: Are sensitive attributes assigned securely, not through hidden fields?
  > Evidence: `reader_id` (user identity) is always set via `Current.user.user_books.find_or_initialize_by(...)` in `UserBooksController`. Never via hidden fields. Password is handled by `has_secure_password`. The book data passed via hidden fields in search results (`title`, `author`, `source_id`) is external API data, not sensitive user attributes.

- [x] **Strong Params**: Are strong parameters used to prevent form vulnerabilities?
  > Evidence: `UsersController` uses `params.expect(user: [...])` (Rails 8 syntax). `UserBooksController` uses `params.require(:user_book).permit(:book_id, :status, :rating)`. `SessionsController` uses `params.permit(:email_address, :password)`.

- [ ] **Authorization**: Is an authorization framework employed to manage user permissions?
  > Pundit is included (`gem "pundit"`, `include Pundit::Authorization`), and policies exist in `app/policies/`. However:
  > 1. `UserBooksController` has **zero** `authorize` calls. The security relies entirely on `Current.user` scoping, which is correct but means Pundit is not actually enforced for the primary CRUD resource.
  > 2. `UserBookPolicy` references `record.user_id` (line 3, 7, 11) but `UserBook` uses `reader_id` — this policy method would always return `nil == user.id` (false). The policy is broken.
  > 3. `UserPolicy#show?` returns `user == record`, meaning users cannot view *other* users' profiles — but the app's core feature (viewing other readers' libraries) requires this. This policy appears to be too restrictive for the intended functionality.

### Score (4/5):

### Notes:
**Critical issue not captured by the rubric checkboxes:** `ApplicationController` line 4 includes `skip_forgery_protection`. This **disables Rails' CSRF protection entirely** for all controllers. CSRF protection is a fundamental Rails security mechanism that prevents cross-site request forgery attacks. This should be removed immediately. Replacing it with `protect_from_forgery with: :exception` (the Rails default) or ensuring authenticity tokens are included in forms would restore this protection. This is a P0 security vulnerability.

---

## Features (each: 1 point - max: 15 points)

- [x] **Sending Email**: Does the application send transactional emails?
  > Evidence: `app/mailers/passwords_mailer.rb` — `PasswordsMailer.reset(user).deliver_later`. Password reset emails sent via Mailtrap in production. `app/views/passwords_mailer/reset.html.erb` view exists.

- [ ] **Sending SMS**: Does the application send transactional SMS messages?
  > No SMS functionality.

- [ ] **Building for Mobile**: Implementation of a Progressive Web App (PWA)?
  > `app/views/layouts/application.html.erb` line 12 — PWA manifest link is commented out: `<%#= tag.link rel: "manifest", href: pwa_manifest_path(format: :json) %>`. Not implemented.

- [ ] **Advanced Search and Filtering**: Incorporation of advanced search and filtering capabilities?
  > `BooksController#search` uses a raw `ILIKE` query: `Book.where("title ILIKE ? OR author ILIKE ?", ...)`. No Ransack or advanced filtering. No genre or rating filters (there is a `<%# TODO: Add filters %>` comment in the search partial).

- [ ] **Data Visualization**: Integration of charts or graphs?
  > No data visualization.

- [x] **Dynamic Meta Tags**: Dynamic generation of meta tags?
  > Evidence: `app/views/shared/_meta_tags.html.erb` — uses the `meta-tags` gem (`gem "meta-tags"` in Gemfile) with `display_meta_tags` helper. Includes OG title, description, image, and site_name.

- [ ] **Pagination**: Use of pagination libraries?
  > No pagination. Recommended books, library shelves, and search results are all rendered without pagination, which could be a UX issue at scale.

- [ ] **Internationalization (i18n)**: Support for multiple languages?
  > No i18n configuration.

- [ ] **Admin Dashboard**: Creation of an admin panel?
  > No admin dashboard.

- [ ] **Business Insights Dashboard**: Creation of an insights dashboard?
  > No insights dashboard.

- [ ] **Enhanced Navigation**: Are breadcrumbs or similar used?
  > No breadcrumbs. The app uses "Go back" links (using `link_to :back`) on book detail and search pages, which is functional but not a navigation enhancement.

- [ ] **Performance Optimization**: Is the Bullet gem used?
  > Bullet is not in the Gemfile. No N+1 detection tools configured.

- [x] **Stimulus**: Implementation of Stimulus.js?
  > Evidence: `app/javascript/controllers/modal_controller.js` — full Stimulus controller with accessibility features (focus trapping, ESC key, backdrop click). Well-implemented with proper connect/disconnect lifecycle management.

- [ ] **Turbo Frames**: Implementation of Turbo Frames?
  > `Turbo.session.drive = false` in `application.js` globally disables Turbo. No Turbo Frames or Turbo Streams are used anywhere in the views.

- [x] **Other**: Open Library API integration.
  > Evidence: `app/services/open_library_client.rb` — HTTParty-based client for the Open Library API, handling search and work detail fetching (including redirect handling). `app/services/book_search_service.rb` and `app/services/book_persistence_service.rb` provide a clean service layer. This meaningfully extends the app's value — users can search millions of books, not just a seeded dataset.

### Score (4/15):

### Notes:
The Open Library API integration is genuinely impressive and well-executed. The Stimulus modal controller shows solid JavaScript fundamentals. The biggest missed opportunity is Turbo — globally disabling it forfeits the AJAX point AND the Turbo Frames point. Re-enabling Turbo and using Turbo Frames for the book search results or rating updates would gain 2 points immediately.

---

## Ambitious Features (each: 2 points - max: 16 points)

- [ ] **Receiving Email**: Does the application handle incoming emails?
  > No ActionMailbox or incoming email handling.

- [ ] **Inbound SMS**: Does the application handle receiving SMS messages?
  > No inbound SMS.

- [ ] **Web Scraping Capabilities**: Incorporation of web scraping functionality?
  > No web scraping. The Open Library API integration uses their official API, not scraping.

- [x] **Background Processing**: Are background jobs implemented for time-consuming processes?
  > Evidence: `app/mailers/passwords_mailer.rb` — `PasswordsMailer.reset(user).deliver_later` uses `ActiveJob`. `config/environments/production.rb` — `config.active_job.queue_adapter = :solid_queue`. Solid Queue is configured with all required schema tables (`solid_queue_*`). The `deliver_later` call queues the email as a background job. Note: No custom `ApplicationJob` subclasses or explicit job files exist beyond `app/jobs/application_job.rb` — the background processing is limited to mailer jobs.

- [ ] **Mapping and Geolocation**: Use of mapping or geocoding libraries?
  > No mapping or geolocation.

- [ ] **Cloud Storage Integration**: Integration with cloud storage services?
  > Active Storage is configured (`config.active_storage.service = :local` in production — should be `:amazon` or similar for production), but no file uploads are implemented.

- [ ] **Chat GPT or AI Integration**: Implementation of AI services?
  > No AI integration. The "taste matching" algorithm is implemented in-house via SQL queries.

- [ ] **Payment Processing**: Implementation of a payment gateway?
  > No payment processing.

- [ ] **OAuth**: Implementation of OAuth?
  > No OAuth. Custom authentication via `has_secure_password`.

- [ ] **Other**: Any other ambitious features?
  > The recommendation algorithm (taste matching by shared reading history) is the most distinctive feature, but it is implemented as standard ActiveRecord queries rather than requiring an "ambitious" external integration.

### Score (2/16):

### Notes:
The background processing point is awarded because `deliver_later` is genuinely using Solid Queue as the backend — this is not just a configuration, it will run the email delivery asynchronously in production. The score here mainly reflects scope — this is an MVP-focused project. Adding OAuth (Devise + OmniAuth, or the built-in Rails authentication generator with OAuth) or an AI integration (even simple recommendations using the OpenAI API) would be the highest-value additions.

---

## Technical Score (/100):

| Section | Score | Max |
|---|---|---|
| Readme | 4 | 10 |
| Version Control | 8 | 10 |
| Code Hygiene | 6 | 8 |
| Patterns of Enterprise Applications | 6 | 10 |
| Design | 5 | 5 |
| Frontend | 9 | 10 |
| Backend | 8 | 9 |
| Quality Assurance and Testing | 0 | 2 |
| Security and Authorization | 4 | 5 |
| Features | 4 | 15 |
| Ambitious Features | 2 | 16 |
| **Total** | **56** | **100** |

---

## Additional overall comments for the entire review may be added below:

**Summary**

Book Match is a cohesive, well-conceived product with a clear problem statement and a clean domain model. The data layer and service objects are the strongest parts of the codebase — the scoped associations, counter caches, and three-layer service architecture (`Client → SearchService → PersistenceService`) show genuine Rails knowledge. The Open Library API integration is well-executed and meaningfully extends the app.

**What's working well:**
- Clean domain model with smart use of scoped associations and counter caches
- Service object layer with proper `self.call` convention and error handling
- Pundit is wired up (even if not fully applied)
- CI/CD pipeline with Brakeman, importmap audit, and Rubocop
- Mailtrap for transactional email with `deliver_later` and Solid Queue
- Strong use of partials for view composition
- Overall branching and PR workflow is solid

**What's blocking a higher score:**

1. **`skip_forgery_protection` in ApplicationController** — this is the most critical issue. It disables CSRF protection across the entire app.

2. **Turbo globally disabled** — this costs 2 rubric points (AJAX, Turbo Frames) and meaningfully limits the user experience. Reversing this would be one of the highest-ROI changes.

3. **No tests** — the RSpec infrastructure exists but nothing is tested. Even 5-10 model specs for `User#bookmates` and `User#recommended_books` would demonstrate testing competency.

4. **UserBookPolicy is broken** — `record.user_id` should be `record.reader_id`. And `UserBooksController` never calls `authorize`, so Pundit isn't actually protecting the main resource.

5. **README needs work** — missing credential setup instructions, ERD link, and contribution guidelines.

**Apprenticeship Readiness Assessment:**

The project demonstrates solid Rails fundamentals and is deployed (bookmatch.site is referenced in production config). With the CSRF vulnerability fixed, Turbo re-enabled, and a minimal test suite added, this would be a strong capstone. As-is, the security gap is a blocker for a "production-ready" designation.
