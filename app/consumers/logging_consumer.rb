# app/consumers/logging_consumer.rb
class LoggingConsumer
  include Sneakers::Worker

  from_queue 'logging.service',
             exchange: 'demo.fanout',
             exchange_type: :fanout,
             durable: true,
             ack: true,
             threads: 2,
             prefetch: 10

  def work(msg)
    data = JSON.parse(msg)

    # Simulate logging to file/service
    sleep 0.3

    ack!
  rescue => e
    Rails.logger.error "❌ [LOGGING] Error: #{e.message}"
    reject!
  end
end
