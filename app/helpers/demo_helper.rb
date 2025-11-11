# app/helpers/demo_helper.rb
module DemoHelper
  # Demo constants
  DEFAULT_EMAIL = "demo@example.com".freeze
  DEFAULT_IMAGE_URL = "https://example.com/image.jpg".freeze
  DEFAULT_PRODUCT = "MacBook Pro".freeze
  DEFAULT_AMOUNT = 3000
  DEFAULT_COUNTRY = "vn".freeze

  # Country options
  COUNTRY_OPTIONS = [
    ['Vietnam', 'vn'],
    ['USA', 'us'],
    ['Global', 'global']
  ].freeze

  COUNTRY_OPTIONS_SHORT = [
    ['Vietnam', 'vn'],
    ['USA', 'us']
  ].freeze

  # Priority options
  PRIORITY_OPTIONS = [
    ['High', 'high'],
    ['Medium', 'medium'],
    ['Low', 'low']
  ].freeze

  # Format options
  FORMAT_OPTIONS = [
    ['PDF', 'pdf'],
    ['DOCX', 'docx'],
    ['XLSX', 'xlsx']
  ].freeze

  # Size options
  SIZE_OPTIONS = [
    ['Large', 'large'],
    ['Medium', 'medium'],
    ['Small', 'small']
  ].freeze

  # Icons
  ICONS = {
    sidekiq: '⚡',
    rabbitmq: '🐰',
    email: '📧',
    image: '🖼️',
    order: '📦',
    paid: '💰',
    shipped: '🚚',
    direct: '🎯',
    headers: '🔖',
    demo: '🚀',
    docs: '📚'
  }.freeze

  def icon(name)
    ICONS[name.to_sym] || name.to_s
  end

  def default_email
    DEFAULT_EMAIL
  end

  def default_image_url
    DEFAULT_IMAGE_URL
  end

  def default_product
    DEFAULT_PRODUCT
  end

  def default_amount
    DEFAULT_AMOUNT
  end

  def default_country
    DEFAULT_COUNTRY
  end

  def country_options
    COUNTRY_OPTIONS
  end

  def country_options_short
    COUNTRY_OPTIONS_SHORT
  end

  def priority_options
    PRIORITY_OPTIONS
  end

  def format_options
    FORMAT_OPTIONS
  end

  def size_options
    SIZE_OPTIONS
  end
end
