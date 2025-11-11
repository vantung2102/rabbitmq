module Orders
  class VietnamInventoryWorker
    include Sneakers::Worker

    from_queue 'orders.inventory.vn',
      exchange: 'app.orders',
      exchange_type: :topic,
      routing_key: '#.vn',  # Matches: order.created.vn, order.paid.vn, order.shipped.vn
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      data = JSON.parse(msg)

      country = data['country']

      puts "[VIETNAM INVENTORY WORKER][#{country}] - Order ID: #{data['order_id']}"

      ack!
    rescue => e
      Rails.logger.error "[VIETNAM INVENTORY] Error: #{e.message}"
      reject!
    end
  end
end
