# app/consumers/analytics_consumer.rb
class AnalyticsConsumer
  include Sneakers::Worker

  from_queue 'analytics.service',
             exchange: 'demo.fanout',
             exchange_type: :fanout,
             durable: true,
             ack: true,
             threads: 2,
             prefetch: 10

  def work(msg)
    data = JSON.parse(msg)

    # Simulate analytics tracking
    sleep 0.5

    ack!
  rescue => e
    Rails.logger.error "❌ [ANALYTICS] Error: #{e.message}"
    reject!
  end
end
