# == Schema Information
#
# Table name: user_books
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#  reader_id  :bigint           not null
#
# Indexes
#
#  index_user_books_on_book_id                (book_id)
#  index_user_books_on_reader_id              (reader_id)
#  index_user_books_on_reader_id_and_book_id  (reader_id,book_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (reader_id => users.id)
#
class UserBook < ApplicationRecord
  belongs_to :reader, required: true, class_name: "User", foreign_key: "reader_id", counter_cache: :books_count
  belongs_to :book, required: true, class_name: "Book", foreign_key: "book_id", counter_cache: :user_books_count

  validates :book_id, uniqueness: { scope: :reader_id }
end
