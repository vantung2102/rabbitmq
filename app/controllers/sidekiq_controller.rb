# app/controllers/sidekiq_controller.rb
class SidekiqController < ApplicationController
  layout 'application'

  def send_email
    email = params[:email] || "demo@example.com"

    # Queue Sidekiq job
    EmailWorker.perform_async(rand(10000..99999), email)

    flash[:success] = "✅ Email job queued! Check Sidekiq Web UI at /sidekiq"
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to queue email job: #{e.message}"
    redirect_to demo_index_path
  end

  def process_image
    image_url = params[:image_url] || "https://example.com/image.jpg"

    # Queue Sidekiq job
    ImageProcessingWorker.perform_async(rand(10000..99999), image_url)

    flash[:success] = "✅ Image processing job queued! Check Sidekiq Web UI at /sidekiq"
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to queue image job: #{e.message}"
    redirect_to demo_index_path
  end
end
