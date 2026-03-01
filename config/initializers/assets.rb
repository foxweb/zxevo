Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w[
  rails_admin/application.js
  rails_admin/application.css
  rails_admin/*.eot
  rails_admin/*.svg
  rails_admin/*.ttf
  rails_admin/*.woff
  rails_admin/*.woff2
]

if defined?(Ckeditor)
  Rails.application.config.assets.precompile += Ckeditor.assets if Ckeditor.respond_to?(:assets)
  Rails.application.config.assets.precompile += Ckeditor.plugins if Ckeditor.respond_to?(:plugins)
  Rails.application.config.assets.precompile += Ckeditor.skin if Ckeditor.respond_to?(:skin)
end
