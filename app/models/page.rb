class Page < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :slug, :title, :user_id
end
