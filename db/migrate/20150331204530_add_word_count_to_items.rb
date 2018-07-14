class AddWordCountToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :word_count, :integer
  end
end
