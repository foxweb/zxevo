# frozen_string_literal: true

# Локализованная дата/время для отображения (русские названия месяцев через I18n).
# Russian.strftime несовместим с I18n 1.x (Rails 6+): два позиционных аргумента в localize.
module RussianLocalizedDatetime
  extend ActiveSupport::Concern

  def russian_date
    I18n.l(russian_date_source, format: '%d %B %Y, %H:%M', locale: :ru)
  end

  private

  # Переопределите в модели, если нужна не updated_at (например created_at у Post).
  def russian_date_source
    updated_at
  end
end
