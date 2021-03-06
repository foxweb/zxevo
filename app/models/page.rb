class Page < ActiveRecord::Base
  belongs_to :user

  def iso_date
    updated_at.strftime('%FT%T%:z')
  end

  def russian_date
    Russian.strftime(updated_at, '%d %B %Y, %H:%M')
  end
end
