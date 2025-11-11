module Orders
  class DocumentWorker
    include Sneakers::Worker

    from_queue 'orders.documents',
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "================================================"
      puts "[RABBITMQ][DOCUMENT]"
      puts "================================================"

      sleep 1

      ack!
    rescue => e
      puts "[RABBITMQ][DOCUMENT] Error: #{e.message}"
      reject!
    end
  end
end
