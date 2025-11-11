module Orders
  class SmsWorker
    include Sneakers::Worker

    from_queue 'orders.notifications.sms',
      exchange: 'orders.notifications',
      exchange_type: :fanout,
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "================================================"
      puts "[RABBITMQ][SMS] - Order ID - #{payload['order_id']}"
      puts "================================================"

      sleep 1

      ack!
    rescue => e
      Rails.logger.error("[SMS WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
