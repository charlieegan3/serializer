class Extractor
  def initialize(document, url)
    @document = document
    @url = url
    @root_url = 'http://' + URI.parse(url).host.downcase
  end

  def title
    title = Nokogiri::HTML(@document).at_css('title')
    title.text
  end

  def html
    @document = @document.force_encoding('utf-8').encode('utf-8').gsub(/\s+/, ' ')
    @document = Nokogiri::HTML(body)
    @document.css('head, script, nav, comment, noscript, footer, header, svg, canvas, figure, img, figcaption, dialog, caption, button, style, textarea, video, source, input, option, noscipt, menu, iframe, cite').map { |tag| tag.remove }
    @document.xpath('//comment()').remove
    @document.css('font').map { |node| node.replace(node.text) }
    @document.css('table').map { |node| node.replace(node.children) }
    @document.css('tr').map { |node| node.replace("<p>#{node.inner_html}</p>") }
    @document.css('td').map { |node| node.replace("<span>#{node.inner_html}</span>") }
    @document.css('a').map { |node| node.remove if !node.text.empty? && !node['href'].nil? && (node.text.downcase.include?('share') || node['href'].include?('share')) }
    @document.css('a').map { |node|
      node['href'] = @root_url + node['href'] if node['href'] && node['href'][0] == '/'
      node['href'] = @url + node['href'] if node['href'] && node['href'][0..3] != 'http'
    }

    @document.css('section, article').map { |node| node.replace(node.children) }
    @document.enum_for(:traverse).map {|c| c.remove if c.text.nil? || (c.text.gsub(/\s+/, '').length == 0 && c.name != 'br')}

    @document = Readability::Document.new(@document.inner_html, {tags: %w(div p a), attributes: ['href'], remove_empty_nodes: true})

    @document = Nokogiri::HTML(@document.content)

    endings = %w(. ' " ” ! ?)
    @document.css('p').map { |node| node.remove if !endings.include?(node.text[-1]) && node.text.length < 200 }
    @document.css('p').map { |node| node.remove if node.text.include?("\n") }
    @document.css('html').map { |node| node.remove if node.text.nil? }

    @document.css('div').map { |node| node.replace(node.children) }

    @document.enum_for(:traverse).map {|c| c.replace("<p>#{c.text}</p>") if c.name == 'text' && c.parent.children.size == 1 && c.parent.name.match(/p|a|span/).nil? }
    "<!@documentTYPE html><html><head><meta charset=\"UTF-8\"></head>#{@document.at_css('body')}</html>"
  end

  def word_count
    html.to_s.split(/\s+/).size
  end

  private
    def body
      body_start = @document.index('<body') || 0
      body_end = @document.rindex('</body>')|| @document.length
      @document[body_start..body_end+6]
    end
end
