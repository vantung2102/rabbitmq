class ImageJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(image_url)
    puts "Processing image from #{image_url}"
    sleep 5
    puts "Image processed from #{image_url}"
  end
end
