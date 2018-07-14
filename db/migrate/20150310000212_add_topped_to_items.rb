class AddToppedToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :topped, :boolean
  end
end
