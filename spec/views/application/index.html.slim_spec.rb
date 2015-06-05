require 'rails_helper'

RSpec.describe 'application/index', type: :view do
  before(:each) do
    assign(:session, create(:session))
    create(:cloudinary_image)
  end

  it 'displays items' do
    assign(:items, [create(:item)])
    render
    expect(rendered).to include('Article')
  end

  it 'hides twitter icon when 0 or nil count' do
    assign(:items, [
      create(:item, tweet_count: nil),
      create(:item, tweet_count: 0)
    ])
    render
    expect(rendered).to_not include('twitter')
  end

  it 'shows twitter icon when > 0 count' do
    assign(:items, [create(:item, tweet_count: 1)])
    render
    expect(rendered).to include('twitter')
  end

  it 'hides comment url when nil count' do
    assign(:items, [create(:item, comment_url: nil)])
    render
    expect(rendered).to_not include('comments')
  end

  it 'shows comment url when 0 or nil count' do
    assign(:items, [create(:item, comment_url: 'url')])
    render
    expect(rendered).to include('comments')
  end

  it 'shows topped star if topped' do
    assign(:items, [create(:item, topped: true)])
    render
    expect(rendered).to include('&#9733;')
  end

  it 'prompts to mark all as read' do
    assign(:session, create(:session, completed_to: 1.hour.ago))
    assign(:items, [create(:item)])
    render
    expect(rendered).to include('Mark all as read')
  end
end
