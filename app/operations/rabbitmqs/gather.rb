module RabbitMQs
  class Gather < ApplicationOperation
    attr_accessor :connected, :connections, :messages, :queues, :latency

    def call
      return OperationResponse.success(DEFAULTS) unless rabbitmq_connected?

      OperationResponse.success({ connected: true, connections:, messages:, queues:, latency: })
    rescue => e
      Rails.logger.error "Error gathering RabbitMQ stats: #{e.message}"

      OperationResponse.success(DEFAULTS)
    end

    private

    DEFAULTS = {
      connected: false,
      connections: 0,
      messages: 0,
      queues: 0,
      latency: 0
    }.freeze

    QUEUES = [
      'workers.logger'
    ].freeze

    def channel
      @channel ||= RabbitMQ.channel
    end

    def rabbitmq_connected?
      RabbitMQ.connected? && channel
    end

    def connections
      rabbitmq_connected? ? 1 : 0
    end

    def messages
      QUEUES.map do |queue_name|
        queue = channel.queue(queue_name, passive: true)
        queue.message_count if queue
      end.compact.sum
    end

    def queues
      QUEUES.count
    end

    def latency
      0
    end
  end
end
