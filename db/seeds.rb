# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "net/http"
require "json"
require "openssl"

puts "🌱 Seeding books from Open Library..."

Book.destroy_all

BASE_URL = "https://openlibrary.org/search.json"

genres = {
  "Fantasy" => "fantasy",
  "Romance" => "romance",
  "Science Fiction" => "science fiction",
  "Mystery" => "mystery",
  "History" => "history"
}

BOOKS_PER_GENRE = 20

def fetch_open_library(url)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri)
  response = http.request(request)

  JSON.parse(response.body)
end

def fetch_work_description(work_key)
  return nil unless work_key

  data = fetch_open_library("https://openlibrary.org#{work_key}.json")
  desc = data["description"]

  desc.is_a?(Hash) ? desc["value"] : desc
rescue
  nil
end

genres.each do |genre_name, query|
  puts "📚 Fetching #{genre_name} books..."

  data = fetch_open_library(
    "#{BASE_URL}?q=#{URI.encode_www_form_component(query)}&limit=#{BOOKS_PER_GENRE}"
  )

  data["docs"].each do |doc|
    next if doc["title"].blank? || doc["author_name"].blank?

    description = fetch_work_description(doc["key"])

    Book.create!(
      title: doc["title"],
      author: doc["author_name"].first,
      genre: genre_name,
      description: description || "No description available."
    )
  end
end

puts "✅ Seeded #{Book.count} books successfully!"
