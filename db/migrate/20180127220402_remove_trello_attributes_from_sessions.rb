class RemoveTrelloAttributesFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :trello_token, :string
    remove_column :sessions, :trello_username, :string
  end
end
