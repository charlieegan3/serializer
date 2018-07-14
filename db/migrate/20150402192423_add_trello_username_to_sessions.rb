class AddTrelloUsernameToSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :sessions, :trello_username, :string
  end
end
