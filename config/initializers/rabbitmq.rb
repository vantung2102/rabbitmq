# config/initializers/rabbitmq.rb
require 'bunny'

module RabbitMQConfig
  class << self
    attr_accessor :connection, :channel

    def setup
      @connection = Bunny.new(
        host: ENV.fetch('RABBITMQ_HOST', 'localhost'),
        port: ENV.fetch('RABBITMQ_PORT', 5672),
        username: ENV.fetch('RABBITMQ_USER', 'guest'),
        password: ENV.fetch('RABBITMQ_PASS', 'guest')
      )

      @connection.start
      @channel = @connection.create_channel

      # Setup exchanges
      setup_exchanges
    rescue => e
      Rails.logger.error "❌ RabbitMQ connection failed: #{e.message}"
    end

    def setup_exchanges
      # 1. Direct Exchange - for priority routing
      @direct_exchange = @channel.direct('demo.direct', durable: true)

      # 2. Fanout Exchange - for broadcasting
      @fanout_exchange = @channel.fanout('demo.fanout', durable: true)

      # 3. Topic Exchange - for pattern routing (MOST USED)
      @topic_exchange = @channel.topic('demo.topic', durable: true)

      # 4. Headers Exchange - for complex routing
      @headers_exchange = @channel.headers('demo.headers', durable: true)

      # Dead Letter Exchange
      @dlx_exchange = @channel.fanout('demo.dlx', durable: true)
    end

    def direct_exchange
      @direct_exchange
    end

    def fanout_exchange
      @fanout_exchange
    end

    def topic_exchange
      @topic_exchange
    end

    def headers_exchange
      @headers_exchange
    end

    def dlx_exchange
      @dlx_exchange
    end

    def close
      @channel&.close
      @connection&.close
    end
  end
end

# Initialize on Rails startup (for both server and console)
Rails.application.config.after_initialize do
  begin
    RabbitMQConfig.setup
  rescue => e
    Rails.logger.error "⚠️  RabbitMQ setup failed (will retry on first use): #{e.message}"
  end
end
