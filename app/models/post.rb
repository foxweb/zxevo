class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :title, :user_id

  def link
    "http://zx.rediron.ru/posts/#{id}"
  end

  def comments_on
    true
  end
end
