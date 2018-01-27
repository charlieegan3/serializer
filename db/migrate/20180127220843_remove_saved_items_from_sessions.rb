class RemoveSavedItemsFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :saved_items, :string
  end
end
