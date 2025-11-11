module Orders
  class Export < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      exchange = RabbitMQ.channel.headers('order.documents', durable: true)

      document_all_queue = RabbitMQ.channel.queue('orders.documents', durable: true)
      document_all_queue.bind(exchange, arguments: arguments)

      exchange.publish(message.to_json, headers: headers)

      OperationResponse.success({ message: 'Document exported successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to export document: #{e.message}" })
    end

    private

    def message
      @message ||= {
        id: rand(1000..9999),
        content: "Document processing request",
        timestamp: Time.now.iso8601
      }
    end

    def headers
      {
        'format' => params[:format].to_s,
        'priority' => params[:priority].to_s,
        'size' => params[:size].to_s,
      }
    end

    def arguments
      {
        'x-match' => 'all',
        'format' => 'pdf',
        'priority' => 'high',
        'size' => 'large',
      }
    end
  end
end
