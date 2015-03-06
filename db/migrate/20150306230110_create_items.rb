class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :url
      t.string :title

      t.timestamps null: false
    end
  end
end
