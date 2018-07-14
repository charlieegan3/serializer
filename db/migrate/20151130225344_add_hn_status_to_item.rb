class AddHnStatusToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :hn_status, :boolean
  end
end
