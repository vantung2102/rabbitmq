module Orders
  class PaymentWorker
    include Sneakers::Worker

    from_queue 'orders.payment.process',
      exchange: 'orders.payment',
      exchange_type: :direct,
      routing_key: 'payment.process',
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    MAX_RETRIES = 5

    def work(msg)
      payload = JSON.parse(msg)
      retry_count = 0

      begin
        puts "================================================"
        puts "[PAYMENT PROCESS] - Order: #{payload['order_id']}"

        # raise if rand(100) < 50

        puts "================================================"
        sleep 0.5
        puts "[PAYMENT PROCESS] Success"

        ack!
      rescue => e
        puts "================================================"
        puts "[PAYMENT ERROR]"

        if retry_count < MAX_RETRIES
          puts "[PAYMENT RETRY] Requeuing... (#{retry_count}/#{MAX_RETRIES})"
          retry_count += 1
          sleep 1

          retry
        else
          puts "[PAYMENT RETRY] Max retries reached (#{retry_count}/#{MAX_RETRIES})"
          reject!
        end

        puts "================================================"
      end
    end
  end
end
