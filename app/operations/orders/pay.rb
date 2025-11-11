module Orders
  class Pay < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end
  end

  def call
    RabbitMQ::Publisher.topic('orders.accounting', order, routing_key: "order.paid.#{params[:country]}")

    OperationResponse.success({ message: 'Order paid successfully' })
  rescue => e
    OperationResponse.failure({ message: "Failed to publish paid order: #{e.message}" })
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
