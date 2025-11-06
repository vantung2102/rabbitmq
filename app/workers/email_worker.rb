class EmailWorker < ApplicationWorker
  sidekiq_options queue: 'default', retry: 3

  def perform(order_id, email)
    sleep 2
  end
end
