class AddUrlToItemIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :items, :url, unique: true
  end
end
