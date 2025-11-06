# app/workers/email_worker.rb
class EmailWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(order_id, email)
    # Simulate email sending
    sleep 2
  end
end
