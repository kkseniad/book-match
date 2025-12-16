class CreateUserBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :user_books do |t|
      t.references :reader, null: false, foreign_key: { to_table: :users }
      t.references :book,   null: false, foreign_key: true

      t.string :status
      t.integer :rating

      t.timestamps
    end

    add_index :user_books, [:reader_id, :book_id], unique: true
  end
end
