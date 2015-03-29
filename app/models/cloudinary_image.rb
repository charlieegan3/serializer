class CloudinaryImage < ActiveRecord::Base
  def self.current_graph_url
    find_by_identifier('graph').url if count > 0
  end
end
