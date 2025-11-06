# app/workers/image_processing_worker.rb
class ImageProcessingWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(order_id, image_url)
    # Simulate image processing
    sleep 1.5
  end
end
