class RemoveSavedItemsFromSessions < ActiveRecord::Migration[4.2]
  def change
    remove_column :sessions, :saved_items, :string
  end
end
