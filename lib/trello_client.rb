require 'trello'
require 'open-uri'
require 'json'

class TrelloClient
  include Trello

  def initialize(token, username = nil)
    @key = ENV['TRELLO_KEY']
    @token = token
    @username = username
    Trello.configure do |config|
      config.developer_public_key = @key
      config.member_token = @token
    end
  end

  def fetch_username
    @username = JSON.parse(open("https://trello.com/1/members/me?key=#{@key}&token=#{@token}&fields=username").read)['username']
  end

  def add_item(item)
    user = Member.find(@username)
    board = user.boards(filter: :open)
            .to_ary
            .target
            .select { |b| b.name == 'Reading List' }
            .first

    board = setup unless board

    if board.lists.collect(&:name).include?('New')
      new_list = board.lists.select { |l| l.name == 'New' }.first
    else
      new_list = create_new_list(board)
    end

    Card.create(name: item[:title],
                desc: item[:description],
                list_id: new_list.id)
  end

  def setup
    board = Board.create(name: 'Reading List')
    board.lists.map(&:close!)
    List.create(board_id: board.id, name: 'One Day')
    List.create(board_id: board.id, name: 'Saved')
    List.create(board_id: board.id, name: 'Unsorted')
    board
  end

  def create_new_list(board)
    List.create(board_id: board.id, name: 'New')
  end

  def clear
    user.boards(filter: :open).each do |b|
      b.update_fields('closed' => true)
      b.save
    end
  end
end
