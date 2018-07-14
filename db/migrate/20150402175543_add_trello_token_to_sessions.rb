class AddTrelloTokenToSessions < ActiveRecord::Migration[4.2]
  def change
    add_column :sessions, :trello_token, :string
  end
end
