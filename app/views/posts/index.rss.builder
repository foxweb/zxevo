@posts.each do |item|
  xml.item do
    xml.guid item.link

    xml.author item.user.name if item.user.present?

    xml.title item.title
    xml.link item.link

    xml.description do
      xml.cdata! item.body if item.body
    end

    xml.pubDate item.created_at.in_time_zone.to_s(:rfc822)
  end
end
