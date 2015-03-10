class AddToppedToItems < ActiveRecord::Migration
  def change
    add_column :items, :topped, :boolean
  end
end
