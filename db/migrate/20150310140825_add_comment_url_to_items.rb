class AddCommentUrlToItems < ActiveRecord::Migration
  def change
    add_column :items, :comment_url, :string
  end
end
