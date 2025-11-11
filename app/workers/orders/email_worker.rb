module Orders
  class EmailWorker
    include Sneakers::Worker

    from_queue 'orders.notifications.email',
      exchange: 'orders.notifications',
      exchange_type: :fanout,
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "Processing email notification: Order ID - #{payload['order_id']}"

      ack!
    rescue => e
      Rails.logger.error("[EMAIL WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
