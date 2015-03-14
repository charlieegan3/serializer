require_relative '../../config/environment'

class Time
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end
end

def counts(array)
 array.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.inject({}) { |r, e| r[e.first] = e.last; r }.sort_by {|k,v| k}.collect { |x| x[1] }
end

task :save_graph do
  times = Item.where('created_at >= ?', Time.zone.now - 30.hours).order(created_at: 'ASC').pluck(:created_at).map { |x| x.round_off(90.minutes) }
  g = Gruff::Line.new(300)
  g.theme = { colors: ['#9ACD32'], background_colors: 'transparent' }
  g.hide_line_markers = true
  g.dot_radius = 0
  g.hide_legend = true
  g.label_max_size = 0
  g.data :line, counts(times)
  RAILS_ROOT = Rails.root unless defined? RAILS_ROOT
  g.write(Rails.root.join("#{RAILS_ROOT}/tmp/graph.png"))
  url = Cloudinary::Uploader.upload("#{RAILS_ROOT}/tmp/graph.png", public_id: 'graph')['url']

  image = CloudinaryImage.find_by_identifier('graph') || CloudinaryImage.new(identifier: 'graph')
  image.update_attribute(:url, url)
end
