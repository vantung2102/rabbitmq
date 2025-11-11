require 'bunny'

module RabbitMQ
  class << self
    attr_accessor :connection, :channel

    def channel
      setup unless connected? && @channel&.open?

      @channel
    end

    def connection
      setup unless connected?

      @connection
    end

    def disconnect
      @channel&.close
      @connection&.close
      @connection = nil
      @channel = nil
    end

    private

    def setup
      @connection = Bunny.new(
        host: ENV.fetch('RABBITMQ_HOST', 'localhost'),
        port: ENV.fetch('RABBITMQ_PORT', '5672').to_i,
        username: ENV.fetch('RABBITMQ_USER', 'guest'),
        password: ENV.fetch('RABBITMQ_PASS', 'guest'),
        vhost: ENV.fetch('RABBITMQ_VHOST', '/'),
        automatically_recover: true,
        network_recovery_interval: 5
      )

      @connection.start
      @channel = @connection.create_channel

      setup_bindings
    end

    def setup_bindings
      rabbitmq_bindings.each do |exchange_type, bindings|
        bindings.each do |binding|
          binding.each do |exchange_name, queue_names|
            exchange = declare_exchange(@channel, exchange_type, exchange_name.to_s)

            queue_names.each do |queue_name|
              queue = @channel.queue(queue_name.to_s, durable: true)
              queue.bind(exchange)
            end
          end
        end
      end
    end

    def declare_exchange(channel, exchange_type, exchange_name)
      case exchange_type.to_s
      when 'direct'
        channel.direct(exchange_name, durable: true)
      when 'fanout'
        channel.fanout(exchange_name, durable: true)
      when 'topic'
        channel.topic(exchange_name, durable: true)
      when 'headers'
        channel.headers(exchange_name, durable: true)
      else
        raise ArgumentError, "Unsupported exchange type: #{exchange_type}"
      end
    end

    def rabbitmq_bindings
      @bindings ||= Rails.application.config_for(:rabbitmq_bindings)
    end

    def connected?
      @connection&.connected?
    end
  end

  class Publisher
    class << self
      def direct(exchange_name, message, **options)
        publish(:direct, exchange_name, message, **options)
      end

      def fanout(exchange_name, message, **options)
        publish(:fanout, exchange_name, message, **options)
      end

      def topic(exchange_name, message, **options)
        publish(:topic, exchange_name, message, **options)
      end

      def headers(exchange_name, message, **options)
        publish(:headers, exchange_name, message, **options)
      end

      private

      def publish(exchange_type, exchange_name, message, **options)
        exchange = channel.public_send(exchange_type, exchange_name, durable: true)

        # Default options cho reliability
        publish_options = {
          persistent: true,
          content_type: 'application/json',
          timestamp: Time.now.to_i
        }.merge(options)

        exchange.publish(message.to_json, publish_options)
      rescue StandardError => e
        Rails.logger.error("Failed to publish message: #{e.message}")
      end


      def channel
        @channel ||= RabbitMQ.channel
      end
    end
  end
end
