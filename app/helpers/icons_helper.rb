module IconsHelper
  # Lucide icon helper (for SVG icons)
  # Usage: lucide_icon(:rabbitmq) or lucide_icon('rabbit', class: 'w-6 h-6')
  def lucide_icon(name, options = {})
    icon_name = lucide_icon_name(name)
    default_class = options[:class] || 'w-5 h-5'
    tag.i('', data: { lucide: icon_name }, class: default_class, **options.except(:class))
  rescue StandardError => e
    content_tag(:span, "#{name.to_s.dasherize}: #{e}", class: 'ms-1')
  end

  private

  # Map semantic names to Lucide icon names
  def lucide_icon_name(name)
    icon_mapping[name.to_sym] || name.to_s.dasherize
  end

  def icon_mapping
    {
      # Demo & Navigation
      rabbitmq: 'rabbit',
      sidekiq: 'zap',
      demo: 'rocket',
      docs: 'book',

      # Actions & Status
      email: 'mail',
      image: 'image',
      order: 'package',
      paid: 'dollar-sign',
      shipped: 'truck',
      user: 'user',
      check: 'check-circle',
      cross: 'x-circle',
      warning: 'alert-triangle',
      info: 'info',

      # Exchange Types
      direct: 'target',
      fanout: 'radio',
      topic: 'star',
      headers: 'tag',

      # Architecture
      producer: 'send',
      queue: 'inbox',
      consumer: 'settings',
      connection: 'plug',
      channel: 'signal',
      binding: 'link',
      exchange: 'shuffle',
      architecture: 'building-2',

      # Flow & Process
      flow: 'refresh-cw',
      waiting: 'clock',
      fast: 'zap',
      background: 'layers',

      # Sections
      agenda: 'list',
      problem: 'x-circle',
      solution: 'check-circle',
      message_queue: 'inbox',
      message_broker: 'server',
      reliability: 'shield',
      use_cases: 'target',
      comparison: 'scale',
      decision: 'target',
      thank_you: 'heart',

      # Arrows
      arrow_down: 'arrow-down',
      arrow_right: 'arrow-right'
    }
  end
end
