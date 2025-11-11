module Orders
  class DocumentWorker
    include Sneakers::Worker

    from_queue 'orders.documents',
      exchange: 'order.documents',
      exchange_type: :headers,
      arguments: {
        'x-match' => 'all',  # Tất cả headers phải match
        'format' => 'pdf',
        'type' => 'document'
      },
      durable: true,
      ack: true,
      threads: 2,
      prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      format = payload['format'] || 'unknown'
      priority = payload['priority'] || 'unknown'
      size = payload['size'] || 'unknown'

      puts "[DOCUMENT WORKER] Processing document - Format: #{format}, Priority: #{priority}, Size: #{size}"
      puts "[DOCUMENT WORKER] Content: #{payload['content']}"

      # Simulate document processing
      sleep 0.5

      ack!
    rescue JSON::ParserError => e
      Rails.logger.error "[DOCUMENT WORKER] Invalid JSON: #{e.message} msg=#{msg.inspect}"
      reject!
    rescue => e
      Rails.logger.error "[DOCUMENT WORKER] Error: #{e.message}"
      reject!
    end
  end
end
