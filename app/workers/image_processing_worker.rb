class ImageProcessingWorker < ApplicationWorker
  sidekiq_options queue: 'default', retry: 3

  def perform(order_id, image_url)
    sleep 1.5
  end
end
