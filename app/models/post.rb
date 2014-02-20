class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :title, :user_id

  def link
    "http://zx.rediron.ru/posts/#{id}"
  end

  def comments_on
    true
  end

  def self.fresh
    self.order('created_at DESC').limit(5).each
  end
end
