# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding featured books..."

featured_books = [
  # Classics / Literary
  { title: "1984", author: "George Orwell", genre: "Classic" },
  { title: "Animal Farm", author: "George Orwell", genre: "Classic" },
  { title: "Pride and Prejudice", author: "Jane Austen", genre: "Classic" },
  { title: "Jane Eyre", author: "Charlotte Brontë", genre: "Classic" },
  { title: "To Kill a Mockingbird", author: "Harper Lee", genre: "Classic" },
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", genre: "Classic" },
  { title: "Little Women", author: "Louisa May Alcott", genre: "Classic" },
  { title: "Moby-Dick", author: "Herman Melville", genre: "Classic" },
  { title: "Crime and Punishment", author: "Fyodor Dostoevsky", genre: "Classic" },
  { title: "The Catcher in the Rye", author: "J.D. Salinger", genre: "Classic" },

  # Fantasy
  { title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy" },
  { title: "The Fellowship of the Ring", author: "J.R.R. Tolkien", genre: "Fantasy" },
  { title: "Harry Potter and the Sorcerer’s Stone", author: "J.K. Rowling", genre: "Fantasy" },
  { title: "Harry Potter and the Chamber of Secrets", author: "J.K. Rowling", genre: "Fantasy" },
  { title: "A Game of Thrones", author: "George R.R. Martin", genre: "Fantasy" },
  { title: "The Name of the Wind", author: "Patrick Rothfuss", genre: "Fantasy" },
  { title: "The Lion, the Witch and the Wardrobe", author: "C.S. Lewis", genre: "Fantasy" },

  # Sci-Fi
  { title: "Dune", author: "Frank Herbert", genre: "Sci-Fi" },
  { title: "Ender’s Game", author: "Orson Scott Card", genre: "Sci-Fi" },
  { title: "Fahrenheit 451", author: "Ray Bradbury", genre: "Sci-Fi" },
  { title: "The Hitchhiker’s Guide to the Galaxy", author: "Douglas Adams", genre: "Sci-Fi" },
  { title: "Brave New World", author: "Aldous Huxley", genre: "Sci-Fi" },
  { title: "The Martian", author: "Andy Weir", genre: "Sci-Fi" },

  # Mystery / Thriller
  { title: "The Girl with the Dragon Tattoo", author: "Stieg Larsson", genre: "Mystery" },
  { title: "Gone Girl", author: "Gillian Flynn", genre: "Thriller" },
  { title: "The Da Vinci Code", author: "Dan Brown", genre: "Thriller" },
  { title: "The Silence of the Lambs", author: "Thomas Harris", genre: "Thriller" },
  { title: "The Hound of the Baskervilles", author: "Arthur Conan Doyle", genre: "Mystery" },

  # Romance
  { title: "Me Before You", author: "Jojo Moyes", genre: "Romance" },
  { title: "The Notebook", author: "Nicholas Sparks", genre: "Romance" },
  { title: "Outlander", author: "Diana Gabaldon", genre: "Romance" },
  { title: "It Ends with Us", author: "Colleen Hoover", genre: "Romance" },

  # YA
  { title: "The Hunger Games", author: "Suzanne Collins", genre: "YA" },
  { title: "Catching Fire", author: "Suzanne Collins", genre: "YA" },
  { title: "Divergent", author: "Veronica Roth", genre: "YA" },
  { title: "The Fault in Our Stars", author: "John Green", genre: "YA" },
  { title: "Percy Jackson & the Lightning Thief", author: "Rick Riordan", genre: "YA" },

  # Non-fiction
  { title: "Sapiens", author: "Yuval Noah Harari", genre: "Non-fiction" },
  { title: "Educated", author: "Tara Westover", genre: "Non-fiction" },
  { title: "Atomic Habits", author: "James Clear", genre: "Non-fiction" },
  { title: "Becoming", author: "Michelle Obama", genre: "Non-fiction" },
  { title: "The Power of Habit", author: "Charles Duhigg", genre: "Non-fiction" }
]

featured_books.each do |attrs|
  Book.find_or_create_by(title: attrs[:title], author: attrs[:author]) do |book|
    book.genre = attrs[:genre]
    book.featured = true
    book.source = "manual"
  end
end

puts "✅ Seeded #{Book.where(featured: true).count} featured books"
