module Orders
  class Paid < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end
  end

  def call
    RabbitMQ::Publisher.fanout('app.orders', order_data)

    OperationResponse.success({ message: 'Order paid successfully' })
  rescue => e
    OperationResponse.failure({ message: "Failed to publish paid order: #{e.message}" })
  end

  private
end
