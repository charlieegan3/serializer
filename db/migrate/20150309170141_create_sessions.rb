class CreateSessions < ActiveRecord::Migration[4.2]
  def change
    create_table :sessions do |t|
      t.string :identifier
      t.string :sources
      t.datetime :completed_to

      t.timestamps null: false
    end
  end
end
