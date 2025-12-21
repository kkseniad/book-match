class BookSearchService
  def self.call(query)
    new(query).search
  end

  def initialize(query)
    @query = query
  end

  def search
    return [] if @query.blank?
    
    results = OpenLibraryClient.search(@query)
    normalize_results(results)
  rescue StandardError => e
    Rails.logger.error("Book search failed: #{e.message}")
    []
  end

  private

  def normalize_results(results)
    results.map do |book_data|
      {
        source: 'open_library',
        source_id: extract_source_id(book_data['key']),
        title: book_data['title'],
        author: book_data['author_name']&.first,
        description: book_data['first_sentence']&.join(' '),
        genre: book_data['subject']&.first,
        isbn: book_data['isbn']&.first
      }
    end
  end

  def extract_source_id(key)
    key&.split('/')&.last
  end
end
