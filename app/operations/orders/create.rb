module Orders
  class Create < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      # Create
      RabbitMQ::Publisher.topic('app.orders', order_data, routing_key: "order.created.#{params[:country]}")

      # Notify all subscribers
      RabbitMQ::Publisher.fanout('orders.notifications', order_data)

      OperationResponse.success({ message: 'Order created successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to create order: #{e.message}" })
    end

    private

    def order_data
      {
        order_id: rand(10000..99999),
        product: params[:product],
        amount: params[:amount],
        country: params[:country],
        customer_email: params[:email],
        timestamp: Time.now.iso8601
      }
    end
  end
end
