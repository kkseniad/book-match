class BookPersistenceService
  def self.call(book_data, reader, status)
    new(book_data, reader, status).persist
  end

  def initialize(book_data, reader, status)
    @book_data = book_data
    @reader = reader
    @status = status
  end

  def persist
    ActiveRecord::Base.transaction do
      book = find_or_create_book
      user_book = create_or_update_user_book(book)
      { book: book, user_book: user_book }
    end
  end

  private

  def find_or_create_book
    Book.find_or_create_by(source: @book_data[:source], source_id: @book_data[:source_id]) do |book|
      book.title = @book_data[:title]
      book.author = @book_data[:author]
      book.description = @book_data[:description]
      book.genre = @book_data[:genre]
      book.isbn = @book_data[:isbn]
    end
  end

  def create_or_update_user_book(book)
    user_book = UserBook.find_or_initialize_by(reader: @reader, book: book)
    user_book.status = @status
    user_book.save!
    user_book
  end
end
