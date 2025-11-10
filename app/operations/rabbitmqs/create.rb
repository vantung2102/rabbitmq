module RabbitMQs
  class Create < ApplicationOperation
    attr_accessor :worker, :args

    def initialize(worker, args)
      @worker = worker
      @args = args
    end

    def call
      HANDLERS.fetch(worker, -> { raise "Worker #{worker} not found" }).call(args)
    end

    private

    HANDLERS = {
      create_order: ->(args) { OrderPublisher.publish_order_created(args) },
    }.freeze
  end
end
