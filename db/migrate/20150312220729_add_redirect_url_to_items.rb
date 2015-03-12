class AddRedirectUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :redirect_url, :string
  end
end
