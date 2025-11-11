module Orders
  class SmsWorker
    include Sneakers::Worker

    from_queue 'workers.notifications.sms', durable: true, ack: true, threads: 2, prefetch: 10

    def work(msg)
      payload = JSON.parse(msg)

      puts "Processing SMS notification: #{payload}"

      ack!
    rescue => e
      Rails.logger.error("[SMS WORKER] Error: #{e.message} msg=#{msg.inspect}")
      reject!
    end
  end
end
