# frozen_string_literal: true

# Ckeditor: таблица ckeditor_assets с колонкой `type` (STI).
# Подклассы Ckeditor::Picture и Ckeditor::AttachmentFile должны быть загружены
# до первого обращения к данным, иначе ActiveRecord::SubclassNotFound:
# «… is not a subclass of …» при /ckeditor/pictures (см. inheritance.rb find_sti_class).
Rails.application.config.to_prepare do
  %w[Ckeditor::Picture Ckeditor::AttachmentFile].each(&:constantize)
end
