class CreateUserBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :user_books do |t|
      t.integer :reader_id
      t.integer :book_id
      t.string :status
      t.integer :rating

      t.timestamps
    end
  end
end
