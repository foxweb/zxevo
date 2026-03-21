class Post < ActiveRecord::Base
  include RussianLocalizedDatetime

  belongs_to :user

  def link
    Rails.application.routes.url_helpers.post_url(self)
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

  private

  def russian_date_source
    created_at
  end
end
