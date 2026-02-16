# == Schema Information
#
# Table name: books
#
#  id               :bigint           not null, primary key
#  author           :string
#  description      :text
#  featured         :boolean          default(FALSE)
#  genre            :string
#  source           :string
#  title            :string
#  user_books_count :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  source_id        :string
#
# Indexes
#
#  index_books_on_source_and_source_id  (source,source_id) UNIQUE
#
class Book < ApplicationRecord
  has_many :user_books, class_name: "UserBook", foreign_key: "book_id", dependent: :destroy
  has_many :readers, through: :user_books, source: :reader

  validates :title, presence: true

  GENRES = [
    "fiction",
    "fantasy",
    "science fiction",
    "romance",
    "mystery",
    "thriller",
    "horror",
    "historical",
    "biography",
    "self-help",
    "philosophy",
    "psychology",
    "business",
    "children",
    "young adult",
    "classic",
    "sci-fi",
    "non-fiction"
  ]
end
