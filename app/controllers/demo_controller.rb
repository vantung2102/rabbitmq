# app/controllers/demo_controller.rb
class DemoController < ApplicationController
  layout 'application'

  def index; end

  def stats
    # Get Sidekiq stats
    sidekiq_stats = Sidekiq::Stats.new
    sidekiq_workers = Sidekiq::ProcessSet.new.size

    # Get RabbitMQ stats
    rabbitmq_connected = RabbitMQConfig.connection&.open? || false
    rabbitmq_connections = rabbitmq_connected ? 1 : 0

    # Try to get queue message counts from RabbitMQ
    rabbitmq_messages = 0
    rabbitmq_queues = 5 # Default queue count

    begin
      if rabbitmq_connected && RabbitMQConfig.channel
        channel = RabbitMQConfig.channel
        # Count messages in all known queues
        known_queues = [
          'inventory.service',
          'accounting.service',
          'vietnam.warehouse',
          'analytics.service',
          'logging.service'
        ]

        known_queues.each do |queue_name|
          begin
            queue = channel.queue(queue_name, passive: true)
            rabbitmq_messages += queue.message_count if queue
          rescue => e
            # Queue might not exist yet, ignore
          end
        end
      end
    rescue => e
      Rails.logger.debug "Could not get RabbitMQ queue stats: #{e.message}"
    end

    render json: {
      sidekiq: {
        processed: sidekiq_stats.processed || 0,
        failed: sidekiq_stats.failed || 0,
        enqueued: sidekiq_stats.enqueued || 0,
        workers: sidekiq_workers || 0,
        latency: sidekiq_stats.default_queue_latency.to_i || 0
      },
      rabbitmq: {
        connected: rabbitmq_connected,
        connections: rabbitmq_connections,
        messages: rabbitmq_messages,
        queues: rabbitmq_queues,
        latency: 0 # RabbitMQ doesn't have a simple latency metric
      }
    }
  end
end
