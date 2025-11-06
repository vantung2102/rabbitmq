# app/consumers/accounting_consumer.rb
class AccountingConsumer
  include Sneakers::Worker

  from_queue 'accounting.service',
             exchange: 'demo.topic',
             exchange_type: :topic,
             routing_key: 'order.paid.#',  # Matches: order.paid.vn, order.paid.us, etc.
             durable: true,
             ack: true,
             threads: 2,
             prefetch: 10

  def work(msg)
    data = JSON.parse(msg)

    Rails.logger.info "💰 [ACCOUNTING] Processing payment for order ##{data['order_id']}"
    Rails.logger.info "   → Recording revenue: $#{data['amount']}"

    # Simulate accounting process
    sleep 1.5

    Rails.logger.info "   ✅ Payment recorded successfully"

    ack!
  rescue => e
    Rails.logger.error "❌ [ACCOUNTING] Error: #{e.message}"
    reject!
  end
end
