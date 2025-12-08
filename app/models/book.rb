# == Schema Information
#
# Table name: books
#
#  id               :bigint           not null, primary key
#  author           :string
#  description      :text
#  genre            :string
#  title            :string
#  user_book_count  :integer
#  user_books_count :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Book < ApplicationRecord
  has_many :user_book, class_name: "UserBook", foreign_key: "book_id", dependent: :destroy
  has_many :readers, through: :user_book, source: :reader
end
