class AddTweetCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :tweet_count, :integer
  end
end
