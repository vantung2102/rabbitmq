module Sidekiqs
  class Gather < ApplicationOperation
    attr_accessor :processed, :failed, :enqueued, :workers, :latency

    def call
      OperationResponse.success({ processed:, failed:, enqueued:, workers:, latency: })
    end

    private

    def sidekiq_stats
      @sidekiq_stats ||= Sidekiq::Stats.new
    end

    def sidekiq_workers
      @sidekiq_workers ||= Sidekiq::ProcessSet.new.size
    end

    def processed
      sidekiq_stats.processed || 0
    end

    def failed
      sidekiq_stats.failed || 0
    end

    def enqueued
      sidekiq_stats.enqueued || 0
    end

    def workers
      sidekiq_workers || 0
    end

    def latency
      sidekiq_stats.default_queue_latency || 0
    end
  end
end
