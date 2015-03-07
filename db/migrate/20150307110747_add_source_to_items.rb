class AddSourceToItems < ActiveRecord::Migration
  def change
    add_column :items, :source, :string
  end
end
