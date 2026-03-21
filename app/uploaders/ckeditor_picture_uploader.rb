class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/ckeditor/pictures/#{model.id}"
  end

  # CarrierWave 3 + версии (:thumb, :content): гемный process :extract_size вызывается на каждой
  # версии и перезаписывает data_file_size размером превью. Пишем размер и MIME только с оригинала.
  def extract_size
    return if version_name.present?

    model.data_file_size = file.size
    return unless model.respond_to?(:data_content_type=)

    ct = file.content_type
    model.data_content_type = ct if ct.present?
  end

  # После сохранения файла на диск — читаем размеры оригинала (process на версиях даёт неверные width/height).
  after :store, :store_dimensions

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [118, 100]
  end

  version :content do
    process resize_to_limit: [800, 800]
  end

  # Add a white list of extensions that are allowed to be uploaded.
  def extension_white_list
    Ckeditor.image_file_types
  end

  def store_dimensions
    return if version_name.present?
    return unless model.respond_to?(:width=) && model.respond_to?(:height=)

    path = file&.path
    return if path.blank? || !File.exist?(path)

    image = MiniMagick::Image.open(path)
    model.width = image.width
    model.height = image.height
  rescue MiniMagick::Error, StandardError => e
    Rails.logger.warn("[CkeditorPictureUploader] store_dimensions failed: #{e.message}") if defined?(Rails.logger)
  end
end
