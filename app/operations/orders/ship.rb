module Orders
  class Ship < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      RabbitMQ::Publisher.topic('app.orders', order, routing_key: "order.shipped.#{params[:country]}")

      OperationResponse.success({ message: 'Order shipped successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to publish shipped order: #{e.message}" })
    end

    private

    def order
      @order ||= {
        order_id: rand(10000..99999),
        country: params[:country],
        timestamp: Time.now.iso8601
      }
    end
  end
end
