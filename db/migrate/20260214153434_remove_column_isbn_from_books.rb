class RemoveColumnIsbnFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :isbn, :string
  end
end
