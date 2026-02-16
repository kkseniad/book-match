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
      raise ActiveRecord::RecordInvalid.new(book) unless book.persisted?
      user_book = create_or_update_user_book(book)
      { book: book, user_book: user_book }
    end
  end

  private

  def find_or_create_book
    book = Book.find_or_initialize_by(
      source: @book_data[:source],
      source_id: @book_data[:source_id],
    )

    return book if book.persisted?

    enrich_book(book)
    book.save!
    book
  end

  def create_or_update_user_book(book)
    user_book = UserBook.find_or_initialize_by(reader: @reader, book: book)
    user_book.status = @status
    user_book.save!
    user_book
  end

  def enrich_book(book)
    work_details = OpenLibraryClient.fetch_work(book.source_id)

    book.title = @book_data[:title]
    book.author = @book_data[:author]
    book.genre = self.class.extract_genre(work_details)
    book.description = self.class.extract_description(work_details)
  end

  def self.extract_description(work_details)
    desc = work_details["description"]

    case desc
    when String
      desc
    when Hash
      desc["value"]
    else
      nil
    end
  end

  def self.extract_genre(work_details)
    subjects = work_details["subjects"].map(&:downcase)
    Book::GENRES.each do |genre|
      return genre if subjects.include?(genre)
    end

    "other"
  end
end
