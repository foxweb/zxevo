class Post < ActiveRecord::Base
  belongs_to :user

  def link
    "https://zx.rediron.ru/posts/#{id}"
  end

  def comments_on
    true
  end

  def self.fresh
    order('created_at DESC').limit(5)
  end

  def iso_date
    created_at.strftime('%FT%T%:z')
  end

  def russian_date
    Russian::strftime(created_at, '%d %B %Y, %H:%M')
  end
end
