class AddHnStatusToItem < ActiveRecord::Migration
  def change
    add_column :items, :hn_status, :boolean
  end
end
