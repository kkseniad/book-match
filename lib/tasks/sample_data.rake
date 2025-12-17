desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do

  puts "Creating sample data..."

  puts "Adding users..."

  # Add users
  names = [ "Alice", "Bob", "Charlie", "Diana", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy" ]

  names.each do |n|
    user = User.find_or_create_by(email_address: "#{n}@example.com") do |u|
      puts "-- Adding user: #{u.email_address} --"
      u.name = n
      u.password = "password"
    end
  end

  # Add books

  puts "Adding books..."

  50.times do
    title = Faker::Book.title
    author = Faker::Book.author
    genre = Faker::Book.genre

    book = Book.find_or_create_by(title: title, author: author) do |b|
      puts "-- Adding book: #{b.title} by #{b.author} --"
      b.genre = genre
    end
  end

  puts "Adding books to users' libraries..."
  all_books = Book.all.to_a
  all_users = User.all
  STATUS = [ "read", "want_to_read" ]
  RATE = [ 1, 2, 3, 4, 5 ]

  all_users.each do |user|
    num_books = rand(10..15)
    random_books = all_books.sample(num_books)
    random_books.each do |book|
      # Skip if already in library
      next if UserBook.exists?(reader_id: user.id, book_id: book.id)
      UserBook.create(
        reader_id: user.id,
        book_id: book.id,
        status: STATUS.sample,
        rating: RATE.sample
      )
      puts "-- #{user.email_address} added '#{book.title}' --"
    end
  end

  puts "Sample data created successfully!"
  puts "Users: #{User.count}"
  puts "Books: #{Book.count}"
  puts "UserBooks: #{UserBook.count}"

end
