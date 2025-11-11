module Orders
  class EmailWorker
    include Sneakers::Worker

    from_queue 'workers.notifications.email', durable: true, ack: true, threads: 2, prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "Processing email notification: #{payload}"

      ack!
    rescue => e
      Rails.logger.error("[EMAIL WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
