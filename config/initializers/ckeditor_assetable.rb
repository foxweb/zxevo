# frozen_string_literal: true

# При загрузке через CKEditor привязываем файл к текущему пользователю (полиморфный assetable).
Rails.application.config.to_prepare do
  next unless defined?(Ckeditor::PicturesController)

  [Ckeditor::PicturesController, Ckeditor::AttachmentFilesController].each do |controller|
    controller.class_eval do
      private

      def respond_with_asset(asset)
        user = ckeditor_current_user
        asset.assetable = user if user && asset.respond_to?(:assetable=)
        super
      end
    end
  end
end
