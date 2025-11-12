module Orders
  class PaymentWorker
    include Sneakers::Worker

    from_queue 'orders.payment.process',
      exchange: 'orders.payment',
      exchange_type: :direct,
      routing_key: 'payment.process',
      arguments: {
        'x-dead-letter-exchange' => 'orders.payment.dlx',
        'x-dead-letter-routing-key' => 'payment.error'
      },
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    MAX_RETRIES = 5

    # Use metadata headers to track retry count across redeliveries
    def work_with_params(msg, _delivery_info, metadata)
      payload = JSON.parse(msg)
      headers = (metadata && metadata[:headers]) || {}
      retry_count = headers['x-retry-count'].to_i

      begin
        puts "================================================"
        puts "[PAYMENT PROCESS] - Order: #{payload['order_id']} (retry=#{retry_count}/#{MAX_RETRIES})"

        # Simulate failure for demo
        # raise "[PAYMENT FAIL]"

        puts "================================================"
        sleep 0.5
        puts "[PAYMENT PROCESS] Success"

        ack!
      rescue => e
        puts "================================================"
        puts "[PAYMENT ERROR] #{e.message}"

        if retry_count < MAX_RETRIES
          new_retry = retry_count + 1
          puts "[PAYMENT RETRY] Requeueing... (#{new_retry}/#{MAX_RETRIES})"

          publish(
            payload.to_json,
            routing_key: 'payment.process',
            headers: { 'x-retry-count' => new_retry }
          )

          ack!
        else
          puts "[PAYMENT RETRY] Max retries reached (#{retry_count}/#{MAX_RETRIES})"
          reject!
        end

        puts "================================================"
      end
    end
  end
end
