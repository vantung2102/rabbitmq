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

    Rails.logger.info "🇻🇳 [VIETNAM WAREHOUSE] Processing order ##{data['order_id']}"
    Rails.logger.info "   → Preparing shipment in Vietnam"

    # Simulate warehouse process
    sleep 1

    Rails.logger.info "   ✅ Order ready for Vietnam delivery"

    ack!
  rescue => e
    Rails.logger.error "❌ [VIETNAM WAREHOUSE] Error: #{e.message}"
    reject!
  end
end
