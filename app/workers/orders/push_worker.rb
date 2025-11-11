module Orders
  class PushWorker
    include Sneakers::Worker

    from_queue 'workers.notifications.push', durable: true, ack: true, threads: 2, prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "Processing push notification: #{payload}"

      ack!
    rescue => e
      Rails.logger.error("[PUSH WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
