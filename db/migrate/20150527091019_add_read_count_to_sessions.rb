class AddReadCountToSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :sessions, :read_count, :integer
  end
end
