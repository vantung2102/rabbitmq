module Loggers
  class Create < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      RabbitMQ::Publisher.direct('logger', message, routing_key: 'logger')

      OperationResponse.success({ message: 'Logger message published successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to publish with logger: #{e.message}" })
    end

    private

    def message
      {
        id: rand(1000..9999),
        priority: params[:priority],
        content: "Logger message: #{params[:priority]}",
        timestamp: Time.now.iso8601
      }
    end
  end
end
