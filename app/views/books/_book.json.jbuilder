json.extract! book, :id, :title, :author, :genre, :description, :user_book_count, :created_at, :updated_at
json.url book_url(book, format: :json)
