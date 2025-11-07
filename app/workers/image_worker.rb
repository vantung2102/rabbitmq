class ImageWorker < ApplicationWorker
  sidekiq_options queue: 'default', retry: 3

  def perform(image_url)
    sleep 5
  end
end
