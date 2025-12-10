# == Schema Information
#
# Table name: user_books
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer
#  reader_id  :integer
#
class UserBook < ApplicationRecord
  belongs_to :reader, required: true, class_name: "User", foreign_key: "reader_id", counter_cache: true
  belongs_to :book, required: true, class_name: "Book", foreign_key: "book_id", counter_cache: true
end
