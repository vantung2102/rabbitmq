module Orders
  class Export < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      RabbitMQ::Publisher.headers('order.documents', message, headers: headers)

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
      @headers ||= {
        format: params[:format] || 'pdf',
        priority: params[:priority] || 'high',
        size: params[:size] || 'large',
        type: 'document'
      }
    end
  end
end
