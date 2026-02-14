class OpenLibraryClient
  BASE_URL = "https://openlibrary.org"

  def self.search(query)
    new.search(query)
  end

  def self.fetch_work(work_id)
    new.fetch_work(work_id)
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

  def fetch_work(work_id)
    response = HTTParty.get("#{BASE_URL}/works/#{work_id}.json")

    return {} unless response.success?

    body = response.parsed_response

    if body.dig("type", "key") == "/type/redirect"
      redirected_key = body["location"]
      new_work_id = redirected_key.split("/").last
      return fetch_work(new_work_id)
    end

    body
  rescue StandardError => e
    Rails.logger.error("OpenLibrary Work request failed: #{e.message}")
    {}
  end
end
