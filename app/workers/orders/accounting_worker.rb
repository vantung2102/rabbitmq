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

      country = data['country']

      puts "[ACCOUNTING WORKER][#{country}] - Order ID: #{data['order_id']}"

      ack!
    rescue => e
      Rails.logger.error "❌ [ACCOUNTING] Error: #{e.message}"
      reject!
    end
  end
end
