module Orders
  class Create < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      RabbitMQ::Publisher.topic('app.orders', order, routing_key: "order.created.#{params[:country]}")
      RabbitMQ::Publisher.fanout('orders.notifications', order)

      OperationResponse.success({ message: 'Order created successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to create order: #{e.message}" })
    end

    private

    def order
      @order ||= {
        order_id: rand(10000..99999),
        product: params[:product],
        amount: params[:amount],
        country: params[:country],
        timestamp: Time.now.iso8601
      }
    end
  end
end
