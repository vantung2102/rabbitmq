module Orders
  class PaymentProcess < ApplicationOperation
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      RabbitMQ::Publisher.direct('orders.payment', params, routing_key: 'payment.process')

      OperationResponse.success({ message: 'Payment request published successfully' })
    rescue => e
      OperationResponse.failure({ message: "Failed to publish payment: #{e.message}" })
    end
  end
end
