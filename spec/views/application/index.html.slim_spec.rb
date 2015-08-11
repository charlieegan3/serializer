require 'rails_helper'

RSpec.describe 'application/index', type: :view do
  before(:each) do
    assign(:session, create(:session))
    create(:cloudinary_image)
  end

  it 'displays the menu button' do
    render
    expect(rendered).to include('menu')
  end
end
