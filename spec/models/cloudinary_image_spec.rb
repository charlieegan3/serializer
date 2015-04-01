require 'rails_helper'

RSpec.describe CloudinaryImage, :type => :model do
  it 'should return nil for graph url if none exist' do
    expect(CloudinaryImage.current_graph_url).to be_nil
  end
end
