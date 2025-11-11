module Orders
  class AccountingWorker
    include Sneakers::Worker

    from_queue 'orders.accounting',
      exchange: 'app.orders',
      exchange_type: :topic,
      routing_key: 'order.paid.#',  # Matches: order.paid.vn, order.paid.us, etc.
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      data = JSON.parse(msg)

      puts "================================================"
      puts "[RABBITMQ][ACCOUNTING] - Country - #{data['country']}"
      puts "[RABBITMQ][ACCOUNTING] - Order ID - #{data['order_id']}"
      puts "================================================"

      sleep 1

      ack!
    rescue => e
      puts "[RABBITMQ][ACCOUNTING] Error: #{e.message}"
      reject!
    end
  end
end
