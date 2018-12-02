class DropCloudinaryImages < ActiveRecord::Migration[5.2]
  def change
    drop_table :cloudinary_images do |t|
      t.string :identifier
      t.string :url

      t.timestamps null: false
    end
  end
end
