xml.instruct!
xml.rss 'version' => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.language 'ru'
    xml.title rss_title
    xml.description rss_description
    xml.link root_url
    xml.image do
      xml.url app_url('/images/apple-touch-icon-114x114.png')
      xml.title app_host
      xml.link root_url
      xml.width 114
      xml.height 114
    end
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: rss_url
    xml << yield
  end
end
