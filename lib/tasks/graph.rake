require_relative '../../config/environment'

def counts(array)
 array.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.inject({}) { |r, e| r[e.first] = e.last; r }.sort_by {|k,v| k}.collect { |x| x[1] }
end

task :save_graph do
  times = Item.where('created_at >= ?', Time.zone.now - 1.days).order(created_at: 'ASC').pluck(:created_at).map {|x| x.beginning_of_hour }
  g = Gruff::Line.new(300)
  g.theme = { colors: ['#9ACD32'], background_colors: 'transparent' }
  g.hide_line_markers = true
  g.dot_radius = 0
  g.hide_legend = true
  g.label_max_size = 0
  g.data :line, counts(times)
  RAILS_ROOT = Rails.root unless defined? RAILS_ROOT
  g.write(Rails.root.join("#{RAILS_ROOT}/tmp/graph.png"))
  puts Cloudinary::Uploader.upload("#{RAILS_ROOT}/tmp/graph.png", public_id: 'graph')['url']
end
