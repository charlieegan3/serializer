class CreateCloudinaryImages < ActiveRecord::Migration
  def change
    create_table :cloudinary_images do |t|
      t.string :identifier
      t.string :url

      t.timestamps null: false
    end
  end
end
