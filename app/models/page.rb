class Page < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :slug, :title, :user_id, :comments_on, :is_visible
end
