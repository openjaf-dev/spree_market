module Spree
  class MarketConfiguration < Preferences::Configuration
    preference :locale, :string, :default => Rails.application.config.i18n.default_locale
  end
end