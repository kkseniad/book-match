namespace :books do
  desc "Backfill missing descriptions and genres for existing books."
  task backfill_data: :environment do
    books = Book.where(description: [nil, ""])
    puts "Found #{books.count} books to update"

    books.find_each do |book|
      # Find books with empty source_id and fetch id from OpenLibrary
      if book.source_id.blank?
        the_book = OpenLibraryClient.search(book.title).first
        new_id = the_book.dig("key").split("/").last
        book.update(source_id: new_id)
      end

      puts "Updating #{book.title}..."

      work_details = OpenLibraryClient.fetch_work(book.source_id)

      description = BookPersistenceService.extract_description(work_details)
      genre = BookPersistenceService.extract_genre(work_details)

      book.update(
        description: description,
        genre: genre,
      )
    rescue => e
      puts "Failed for #{book.title}: #{e.message}"
    end
    puts "Done"
  end
end
