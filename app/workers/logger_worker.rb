class LoggerWorker
  include Sneakers::Worker

  from_queue 'workers.logger',
    routing_key: 'logger',
    durable: true,
    ack: true,
    threads: 2,
    prefetch: 10

  def work(msg)
    payload = JSON.parse(msg)

    content = payload['content']
    priority = payload['priority']

    puts "content=#{content} priority=#{priority}"

    case priority
    when 'high'
      Rails.logger.info("[LOGGER WORKER] content=#{content} priority=#{priority}")
    when 'medium'
      Rails.logger.warn("[LOGGER WORKER] content=#{content} priority=#{priority}")
    when 'low'
      Rails.logger.error("[LOGGER WORKER] content=#{content} priority=#{priority}")
    end

    ack!
  rescue => e
    Rails.logger.error("[PRIORITY WORKER] Invalid JSON: #{e.message} msg=#{msg.inspect}")
    reject!
  end
end
