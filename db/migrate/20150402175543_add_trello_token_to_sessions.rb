class AddTrelloTokenToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :trello_token, :string
  end
end
