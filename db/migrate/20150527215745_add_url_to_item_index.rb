class AddUrlToItemIndex < ActiveRecord::Migration
  def change
    add_index :items, :url, unique: true
  end
end
