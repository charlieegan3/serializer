class AddTrelloUsernameToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :trello_username, :string
  end
end
