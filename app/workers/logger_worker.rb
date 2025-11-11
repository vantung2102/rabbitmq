class LoggerWorker
  include Sneakers::Worker

  from_queue 'logger',
    exchange: 'logger',
    exchange_type: :direct,
    routing_key: 'logger',
    durable: true,
    ack: true,
    threads: 2,
    prefetch: 10

  def work(msg)
    puts "================================================"

    payload = JSON.parse(msg)

    content = payload['content']
    priority = payload['priority']

    puts "[RABBITMQ][LOGGER] - Priority - #{priority}"
    puts "[RABBITMQ][LOGGER] - Logger ID - #{payload['id']}"

    case priority
    when 'high'
      Rails.logger.info("[LOGGER WORKER] content=#{content} priority=#{priority}")
    when 'medium'
      Rails.logger.warn("[LOGGER WORKER] content=#{content} priority=#{priority}")
    when 'low'
      Rails.logger.error("[LOGGER WORKER] content=#{content} priority=#{priority}")
    end

    puts "================================================"

    ack!
  rescue => e
    Rails.logger.error("[PRIORITY WORKER] Invalid JSON: #{e.message} msg=#{msg.inspect}")
    reject!
  end
end
