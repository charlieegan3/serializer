class AddSourceToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :source, :string
  end
end
