class Page < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :slug, :title, :user_id, :comments_on, :is_visible

  def iso_date
    self.updated_at.strftime('%FT%T%:z')
  end

  def russian_date
    Russian::strftime(self.updated_at, '%d %B %Y, %H:%M')
  end
end
