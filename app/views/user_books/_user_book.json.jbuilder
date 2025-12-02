json.extract! user_book, :id, :reader_id, :book_id, :status, :rating, :created_at, :updated_at
json.url user_book_url(user_book, format: :json)
