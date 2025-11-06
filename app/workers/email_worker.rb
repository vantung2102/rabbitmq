# app/workers/email_worker.rb
class EmailWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(order_id, email)
    Rails.logger.info "📧 [SIDEKIQ EMAIL] Sending email for order ##{order_id} to #{email}"

    # Simulate email sending
    sleep 2

    Rails.logger.info "   ✅ Email sent successfully to #{email}"
  end
end
