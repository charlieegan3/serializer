class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :url
      t.string :title

      t.timestamps null: false
    end
  end
end
