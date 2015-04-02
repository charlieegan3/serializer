class AddSavedItemsToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :saved_items, :text
  end
end
