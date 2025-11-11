module Orders
  class InventoryWorker
    include Sneakers::Worker

    from_queue 'orders.inventory',
      exchange: 'app.orders',
      exchange_type: :topic,
      routing_key: 'order.created.*',  # Matches: order.created.vn, order.created.us, etc.
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      data = JSON.parse(msg)

      puts "================================================"
      puts "[RABBITMQ][INVENTORY] - Country - #{data['country']}"
      puts "[RABBITMQ][INVENTORY] - Order ID - #{data['order_id']}"
      puts "================================================"

      sleep 1

      ::RabbitMQ::Publisher.fanout('orders.notifications', data)

      ack!
    rescue => e
      puts "[RABBITMQ][INVENTORY] Error: #{e.message}"
      reject!
    end
  end
end
