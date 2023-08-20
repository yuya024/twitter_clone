# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # 画像加工
    config.active_storage.variant_processor = :mini_magick
    # 日本語化
    config.i18n.default_locale = :ja
    # timezone
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # field_with_errorsタグを読み込まないようにする
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
      g.factory_bot false
    end
    config.action_view.default_form_builder = 'ApplicationFormBuilder'
  end
end
