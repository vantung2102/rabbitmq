module Orders
  class InventoryWorker
    include Sneakers::Worker

    from_queue 'orders.inventory',
      exchange: 'orders.inventory',
      exchange_type: :topic,
      routing_key: 'order.created.*',  # Matches: order.created.vn, order.created.us, etc.
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      data = JSON.parse(msg)

      country = data['country']

      puts "[INVENTORY WORKER][#{country}] - Order ID: #{data['order_id']}"

      ack!
    rescue => e
      Rails.logger.error "[INVENTORY] Error: #{e.message}"
      reject!
    end
  end
end
