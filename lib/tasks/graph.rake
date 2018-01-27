require_relative '../../config/environment'

class Time
  def round_off(seconds = 60)
    Time.at((to_f / seconds).round * seconds)
  end
end

def counts(array)
  array
    .inject(Hash.new(0)) { |a, e| a[e] += 1; a }
    .inject({}) { |a, e| a[e.first] = e.last; a }
    .sort_by { |k, _| k }
    .collect { |x| x[1] }
end

task :save_graph do
  times = Item.where('created_at >= ?', Time.zone.now - 30.hours)
          .order(created_at: 'ASC')
          .pluck(:created_at)
          .map { |x| x.round_off(90.minutes) }
  g = Gruff::Line.new(300)
  g.theme = { colors: ['#9ACD32'], background_colors: 'transparent' }
  g.hide_line_markers = true
  g.dot_radius = 0
  g.hide_legend = true
  g.label_max_size = 0
  g.data :line, counts(times)
  g.write(Rails.root.join("#{Rails.root}/tmp/graph.png"))

  url = Cloudinary::Uploader.upload("#{Rails.root}/tmp/graph.png",
                                    public_id: 'graph',
                                    cloud_name: ENV['CLOUD_NAME'],
                                    api_key: ENV['CLOUDINARY_KEY'],
                                    api_secret: ENV['CLOUDINARY_SECRET']
                                   )['secure_url']

  image = CloudinaryImage.find_by_identifier('graph') || CloudinaryImage.new(identifier: 'graph')
  image.update_attribute(:url, url)
end
