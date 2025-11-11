# app/services/order_publisher.rb
class OrderPublisher
  TOPIC_EXCHANGE  = ENV.fetch('ORDERS_TOPIC_EXCHANGE',  'demo.topic')
  FANOUT_EXCHANGE = ENV.fetch('ORDERS_FANOUT_EXCHANGE', 'demo.fanout')
  DIRECT_EXCHANGE = ENV.fetch('ORDERS_DIRECT_EXCHANGE', 'app.priority')
  HEADERS_EXCHANGE = ENV.fetch('ORDERS_HEADERS_EXCHANGE', 'app.documents')

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
    routing_key = "order.created.#{order_data[:country]}"

    RabbitMQ::Publisher.topic(
      TOPIC_EXCHANGE,
      order_data,
      routing_key: routing_key
    )

    RabbitMQ::Publisher.fanout(
      FANOUT_EXCHANGE,
      { event: 'order_created', data: order_data }
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish order: #{e.message}"
    raise
  end

  def publish_order_paid(order_data)
    routing_key = "order.paid.#{order_data[:country]}"

    RabbitMQ::Publisher.topic(
      TOPIC_EXCHANGE,
      order_data,
      routing_key: routing_key
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish paid order: #{e.message}"
    raise
  end

  def publish_order_shipped(order_data)
    routing_key = "order.shipped.#{order_data[:country]}"

    RabbitMQ::Publisher.topic(
      TOPIC_EXCHANGE,
      order_data,
      routing_key: routing_key
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish shipped order: #{e.message}"
    raise
  end

  # Demo Headers Exchange - Complex routing
  def self.publish_with_headers(message, headers)
    RabbitMQ::Publisher.headers(
      HEADERS_EXCHANGE,
      message,
      headers: headers
    )
  rescue => e
    Rails.logger.error "❌ Failed to publish with headers: #{e.message}"
    raise
  end
end
