class AddRedirectUrlToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :redirect_url, :string
  end
end
