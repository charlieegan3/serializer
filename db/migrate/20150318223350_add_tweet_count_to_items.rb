class AddTweetCountToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :tweet_count, :integer
  end
end
