class AddSavedItemsToSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :sessions, :saved_items, :text
  end
end
