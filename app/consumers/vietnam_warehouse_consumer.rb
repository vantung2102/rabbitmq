# app/consumers/vietnam_warehouse_consumer.rb
class VietnamWarehouseConsumer
  include Sneakers::Worker

  from_queue 'vietnam.warehouse',
             exchange: 'demo.topic',
             exchange_type: :topic,
             routing_key: '#.vn',  # Matches: order.created.vn, order.paid.vn, order.shipped.vn
             durable: true,
             ack: true,
             threads: 2,
             prefetch: 10

  def work(msg)
    data = JSON.parse(msg)

    # Simulate warehouse process
    sleep 1

    ack!
  rescue => e
    Rails.logger.error "❌ [VIETNAM WAREHOUSE] Error: #{e.message}"
    reject!
  end
end
