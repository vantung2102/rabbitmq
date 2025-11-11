module Orders
  class PushWorker
    include Sneakers::Worker

    from_queue 'orders.notifications.push',
      exchange: 'orders.notifications',
      exchange_type: :fanout,
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "Processing push notification: Order ID - #{payload['order_id']}"

      ack!
    rescue => e
      Rails.logger.error("[PUSH WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
