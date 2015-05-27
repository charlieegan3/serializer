class AddReadCountToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :read_count, :integer
  end
end
