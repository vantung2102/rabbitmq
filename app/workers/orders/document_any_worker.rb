module Orders
  class DocumentAnyWorker
    include Sneakers::Worker

    from_queue 'orders.documents.any',
      exchange: 'order.documents',
      exchange_type: :headers,
      arguments: {
        'x-match' => 'any',  # Chỉ cần 1 header match là được
        'format' => 'pdf',
        'priority' => 'high'
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

      puts "[DOCUMENT ANY WORKER] Processing - Format: #{format}, Priority: #{priority}, Size: #{size}"
      puts "[DOCUMENT ANY WORKER] Content: #{payload['content']}"
      puts "[DOCUMENT ANY WORKER] Matched with x-match: any (chỉ cần format=pdf HOẶC priority=high)"

      # Simulate document processing
      sleep 0.5

      ack!
    rescue JSON::ParserError => e
      Rails.logger.error "[DOCUMENT ANY WORKER] Invalid JSON: #{e.message} msg=#{msg.inspect}"
      reject!
    rescue => e
      Rails.logger.error "[DOCUMENT ANY WORKER] Error: #{e.message}"
      reject!
    end
  end
end
