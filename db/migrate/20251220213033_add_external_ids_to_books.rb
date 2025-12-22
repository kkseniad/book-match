class AddExternalIdsToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :isbn, :string
    add_column :books, :source, :string
    add_column :books, :source_id, :string
    add_column :books, :featured, :boolean, default: false

    add_index :books, :isbn, unique: true
    add_index :books, [ :source, :source_id ], unique: true
  end
end
