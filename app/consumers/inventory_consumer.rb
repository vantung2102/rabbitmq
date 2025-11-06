# app/consumers/inventory_consumer.rb
class InventoryConsumer
  include Sneakers::Worker

  from_queue 'inventory.service',
             exchange: 'demo.topic',
             exchange_type: :topic,
             routing_key: 'order.created.*',  # Matches: order.created.vn, order.created.us, etc.
             durable: true,
             ack: true,
             threads: 2,
             prefetch: 10

  def work(msg)
    data = JSON.parse(msg)

    Rails.logger.info "📦 [INVENTORY] Processing order ##{data['order_id']}"
    Rails.logger.info "   → Checking stock for #{data['product']}"

    # Simulate inventory check
    sleep 1

    Rails.logger.info "   ✅ Stock available, reserved for order ##{data['order_id']}"

    ack! # Acknowledge message
  rescue => e
    Rails.logger.error "❌ [INVENTORY] Error: #{e.message}"
    reject! # Reject and requeue
  end
end
