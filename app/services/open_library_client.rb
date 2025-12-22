class OpenLibraryClient
  BASE_URL = "https://openlibrary.org"

  def self.search(query)
    new.search(query)
  end

  def search(query)
    response = HTTParty.get("#{BASE_URL}/search.json", query: { q: query, limit: 20 })
    if response.success?
      response["docs"] || []
    else
      Rails.logger.error("OpenLibrary API error: #{response.code}")
      []
    end
  rescue StandardError => e
    Rails.logger.error("OpenLibrary API request failed: #{e.message}")
    []
  end
end
