// RailsAdmin 3 + Sprockets: файлы из гема — ES-модули (import/export). Браузер грузит их как
// обычные скрипты → SyntaxError, не инициализируются виджеты и CKEditor.
// Собранный IIFE: npm run build:rails_admin (esbuild → vendor/.../rails_admin_application_bundle.js)
//= require rails_admin_application_bundle
