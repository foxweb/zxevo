xml.instruct!
xml.rss 'version' => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.language 'ru'
    xml.title rss_title
    xml.description rss_description
    xml.link 'http://zx.rediron.ru/'
    xml.image do
      xml.url 'http://zx.rediron.ru/images/apple-touch-icon-114x114.png'
      xml.title 'zx.rediron.ru'
      xml.link 'http://zx.rediron.ru/'
      xml.width 114
      xml.height 114
    end
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: "http://zx.rediron.ru#{request.path}"
    xml << yield
  end
end
