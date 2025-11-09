module Sidekiqs
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
      email: ->(args) { EmailJob.perform_async(args) },
      image: ->(args) { ImageJob.perform_async(args) }
    }.freeze
  end
end
