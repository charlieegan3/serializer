class AddCommentUrlToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :comment_url, :string
  end
end
