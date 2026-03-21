/**
 * Конфиг CKEditor 4 для RailsAdmin (поля :ck_editor).
 * Подключается через config_js в config/initializers/rails_admin.rb (asset_path).
 */
/* global CKEDITOR */
CKEDITOR.editorConfig = function (config) {
  config.language = 'ru';
  config.height = 420;
  config.resize_dir = 'vertical';

  config.toolbarGroups = [
    { name: 'clipboard', groups: ['clipboard', 'undo'] },
    { name: 'editing', groups: ['find', 'selection', 'spellchecker'] },
    { name: 'links' },
    { name: 'insert' },
    { name: 'tools' },
    '/',
    { name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },
    { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'] },
    { name: 'styles' },
    { name: 'colors' },
    { name: 'document', groups: ['mode', 'document', 'doctools'] },
  ];

  config.removeButtons = 'Subscript,Superscript';
  config.format_tags = 'p;h2;h3;h4;pre';

  // Каталог «Обзор сервера» / ранее загруженные картинки (маршруты гема ckeditor)
  // см. gem ckeditor app/assets/javascripts/ckeditor/config.js
  config.filebrowserBrowseUrl = '/ckeditor/attachment_files';
  config.filebrowserFlashBrowseUrl = '/ckeditor/attachment_files';
  config.filebrowserFlashUploadUrl = '/ckeditor/attachment_files';
  config.filebrowserImageBrowseLinkUrl = '/ckeditor/pictures';
  config.filebrowserImageBrowseUrl = '/ckeditor/pictures';
  config.filebrowserImageUploadUrl = '/ckeditor/pictures?';
  config.filebrowserUploadUrl = '/ckeditor/attachment_files';
  config.filebrowserUploadMethod = 'form';
  config.allowedContent = true;
  config.versionCheck = false;
};
