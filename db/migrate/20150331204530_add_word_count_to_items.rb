class AddWordCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :word_count, :integer
  end
end
