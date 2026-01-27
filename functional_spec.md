# Book Match Functional Specification

Book Match: Stop wasting time on books you won't like. Get recommendations from readers who've already proven they have your taste.

## Problem Statement
Book readers don't know what to read next because they can't trust recommendations from strangers. Reviews on Goodreads or Amazon come from people with completely different reading tastes. For instance, someone who loves romance novels reviewing a thriller doesn't help a sci-fi reader. Generic "Top 100" lists and algorithm-based recommendations push popular books, not books the reader will actually enjoy. This results in wasted time reading disappointing books or endless browsing without making a decision.

## Target User Persona
- Reads 15-20 books per year (mix of literary fiction, memoirs, some thrillers)
- Finishes a book and spends 30+ minutes browsing recommendations
- Frustrated because:
  - Goodreads reviews are from people who read completely different genres
  - "Top 100" lists include books she'd never pick up
  - Bookstores/algorithms push bestsellers, not books *she'd* like
- **Wants:** Recommendations from people who've read and loved the same books she has

## Proposed Solution
**Book Match** - A book recommendation app that shows you what to read next based on readers with proven similar taste (shared reading history).
### The Core Insight 
If someone has read 5+ of the same books you've read, their other books are likely good matches for you too.

## Key Features (MVP Scope)

* **Personal Reading Library**
Build your reading profile by adding books, marking them as "Read" or "Want to Read", and optionally rating them 1-5 stars.
* **Taste Match Algorithm**
See book recommendations from readers who share 5+ books with you, with their ratings and the specific books you have in common.
* **Book Discovery**
Browse personalized "For you" recommendations and individual book pages highlighting ratings from readers with similar taste.
* **User Profiles**
View other readers' libraries and see your "taste match score" (number of books in common) to understand compatibility.


## User Stories
- As a user, I want to add books to my library and mark them as "Read" or "Want to Read" so I can build my reading profile.
- As a user, I want to rate books I've read (1-5 stars) so I can remember how much I enjoyed them.
- As a user, I want to see book recommendations from readers who share 5+ books with me so I can trust their suggestions.
- As a user, I want to view which books I have in common with another reader so I understand why their taste matches mine.
- As a user, I want to browse a "Discover" page so I can quickly find my next book based on similar readers' recommendations.
- As a user, I want to view detailed book information (title, author, ratings) so I can decide if I want to read it.
- As a user, I want to see how many readers with similar taste recommend a book so I can gauge if it's right for me.

## Domain Model
<a href="https://docs.google.com/spreadsheets/d/1qrzRxobbkOYM85OQFpGCSdHiU6isD6nTJ74xVV1h1Qo/edit?usp=sharing">Sample Data Spreadsheet</a>
<img width="1245" height="597" alt="Book Match ERD" src="https://gist.github.com/user-attachments/assets/244d3ce0-a17c-4fc1-897e-30ba71bf4d38" />

## Sketches
<img width="2637" height="2401" alt="Book Match Wireframe" src="https://gist.github.com/user-attachments/assets/143e3fc4-32a6-4552-93bf-c3a66e3f03d3" />
