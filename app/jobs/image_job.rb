class ImageJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(image_url)
    puts "================================================"

    puts "[SIDEKIQ][IMAGE JOB] Processing image from #{image_url}"
    sleep 1

    puts "================================================"
  end
end
