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
end
