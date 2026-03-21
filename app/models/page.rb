class Page < ActiveRecord::Base
  include RussianLocalizedDatetime

  belongs_to :user

  def iso_date
    updated_at.strftime('%FT%T%:z')
  end
end
