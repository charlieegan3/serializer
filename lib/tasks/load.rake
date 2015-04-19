require_relative '../../config/environment'

task :load_items do
  `unzip -o db/items.csv -d db/`
  lines = File.open(Rails.root.join('db/items.csv')).readlines
  lines.each_with_index do |item, index|
    next if index == 0

    item = item.split(',')

    Item.create(
      url: item[1][1..-2],
      title: item[2..-9].join(',')[1..-2],
      word_count: item[-1][1..-2],
      tweet_count: item[-2][1..-2],
      redirect_url: item[-3][1..-2],
      comment_url: item[-4][1..-2],
      topped: item[-5].downcase[1..-2],
      source: item[-6][1..-2],
      updated_at: item[-7][1..-2],
      created_at: item[-8][1..-2]
    )

    puts "#{((index.to_f / lines.size) * 100).round(1)}%"
  end
end
