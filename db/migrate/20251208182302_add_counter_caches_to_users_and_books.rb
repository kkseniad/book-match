class AddCounterCachesToUsersAndBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :user_books_count, :integer, default: 0, null: false
    add_column :books, :user_books_count, :integer, default: 0, null: false
  end
end
