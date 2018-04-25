xml.instruct!
xml.rss 'version' => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.language 'ru'
    xml.title rss_title
    xml.description rss_description
    xml.link 'https://zx.rediron.ru/'
    xml.image do
      xml.url 'https://zx.rediron.ru/images/apple-touch-icon-114x114.png'
      xml.title 'zx.rediron.ru'
      xml.link 'https://zx.rediron.ru/'
      xml.width 114
      xml.height 114
    end
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: "https://zx.rediron.ru#{request.path}"
    xml << yield
  end
end
