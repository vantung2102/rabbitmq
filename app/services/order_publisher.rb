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

  def publish_order_created(order_data)
    # Demo 1: Topic Exchange - Pattern-based routing
    routing_key = "order.created.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json',
      timestamp: Time.now.to_i
    )

    Rails.logger.info "📤 Published to Topic Exchange: #{routing_key}"

    # Demo 2: Fanout Exchange - Broadcast to all queues
    RabbitMQConfig.fanout_exchange.publish(
      { event: 'order_created', data: order_data }.to_json,
      persistent: true,
      content_type: 'application/json'
    )

    Rails.logger.info "📤 Broadcasted to Fanout Exchange"
  end

  def publish_order_paid(order_data)
    routing_key = "order.paid.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json'
    )

    Rails.logger.info "📤 Published: #{routing_key}"
  end

  def publish_order_shipped(order_data)
    routing_key = "order.shipped.#{order_data[:country]}"

    RabbitMQConfig.topic_exchange.publish(
      order_data.to_json,
      routing_key: routing_key,
      persistent: true,
      content_type: 'application/json'
    )

    Rails.logger.info "📤 Published: #{routing_key}"
  end

  # Demo Direct Exchange - Priority routing
  def self.publish_with_priority(message, priority)
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

    Rails.logger.info "📤 Published to Direct Exchange: #{routing_key}"
  end

  # Demo Headers Exchange - Complex routing
  def self.publish_with_headers(message, headers)
    RabbitMQConfig.headers_exchange.publish(
      message.to_json,
      headers: headers,
      persistent: true
    )

    Rails.logger.info "📤 Published to Headers Exchange with: #{headers.inspect}"
  end
end
