# app/services/order_publisher.rb
class OrderPublisher
  def self.publish_order_created(order_data)
    new.publish_order_created(order_data)
  end

  def self.publish_order_paid(order_data)
    new.publish_order_paid(order_data)
  end

  def self.publish_order_shipped(order_data)
    new.publish_order_shipped(order_data)
  end

  def ensure_rabbitmq_connected
    # Setup RabbitMQ if not already connected
    if RabbitMQConfig.topic_exchange.nil?
      RabbitMQConfig.setup
    end

    # Verify connection is still open
    if RabbitMQConfig.connection.nil? || !RabbitMQConfig.connection.open?
      RabbitMQConfig.setup
    end

    # Double check exchange exists
    if RabbitMQConfig.topic_exchange.nil?
      raise "❌ RabbitMQ Topic Exchange not available. Please check RabbitMQ connection."
    end
  end

  def publish_order_created(order_data)
    # Ensure RabbitMQ is setup
    ensure_rabbitmq_connected

    # Demo 1: Topic Exchange - Pattern-based routing
    routing_key = "order.created.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json',
      timestamp: Time.now.to_i
    )

    # Demo 2: Fanout Exchange - Broadcast to all queues
    RabbitMQConfig.fanout_exchange.publish(
      { event: 'order_created', data: order_data }.to_json,
      persistent: true,
      content_type: 'application/json'
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish order: #{e.message}"
    raise
  end

  def publish_order_paid(order_data)
    ensure_rabbitmq_connected

    routing_key = "order.paid.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json'
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish paid order: #{e.message}"
    raise
  end

  def publish_order_shipped(order_data)
    ensure_rabbitmq_connected

    routing_key = "order.shipped.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json'
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish shipped order: #{e.message}"
    raise
  end

  # Demo Direct Exchange - Priority routing
  def self.publish_with_priority(message, priority)
    new.ensure_rabbitmq_connected

    routing_key = case priority
    when 'high' then 'priority.high'
    when 'medium' then 'priority.medium'
    else 'priority.low'
    end

    RabbitMQConfig.direct_exchange.publish(
      message.to_json,
      routing_key: routing_key,
      persistent: true,
      priority: priority == 'high' ? 10 : 5
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish with priority: #{e.message}"
    raise
  end

  # Demo Headers Exchange - Complex routing
  def self.publish_with_headers(message, headers)
    new.ensure_rabbitmq_connected

    RabbitMQConfig.headers_exchange.publish(
      message.to_json,
      headers: headers,
      persistent: true
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish with headers: #{e.message}"
    raise
  end
end
