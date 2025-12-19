# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  bio             :text
#  books_count     :integer          default(0), not null
#  email_address   :string           not null
#  name            :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_books, class_name: "UserBook", foreign_key: "reader_id", dependent: :destroy
  has_many :books, through: :user_books, source: :book

  has_many :read_user_books, -> { where(status: "read") }, class_name: "UserBook", foreign_key: "reader_id"
  has_many :read_books, through: :read_user_books, source: :book
  has_many :want_to_read_user_books, -> { where(status: "want_to_read") }, class_name: "UserBook", foreign_key: "reader_id"
  has_many :want_to_read_books, through: :want_to_read_user_books, source: :book

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  # Helper method to check if user has book
  def has_book?(book)
    user_books.exists?(book_id: book.id)
  end
end
