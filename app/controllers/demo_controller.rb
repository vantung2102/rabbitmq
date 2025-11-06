# app/controllers/demo_controller.rb
class DemoController < ApplicationController
  layout 'application'

  def index
    # Main demo page
  end

  def create_order
    order_data = {
      order_id: rand(10000..99999),
      product: params[:product] || "MacBook Pro",
      amount: params[:amount] || 2999,
      country: params[:country] || "vn",
      customer_email: params[:email] || "customer@example.com",
      timestamp: Time.now.iso8601
    }

    # Demo 1: RabbitMQ - Publish to Topic Exchange
    OrderPublisher.publish_order_created(order_data)

    # Demo 2: Sidekiq - Simple background jobs
    EmailWorker.perform_async(order_data[:order_id], order_data[:customer_email])
    ImageProcessingWorker.perform_async(order_data[:order_id], "https://example.com/product.jpg")

    flash[:success] = "✅ Order ##{order_data[:order_id]} created! Check console logs."
    redirect_to demo_index_path
  end

  def paid_order
    order_data = {
      order_id: rand(10000..99999),
      product: "MacBook Pro",
      amount: 2999,
      country: params[:country] || "vn",
      payment_method: "credit_card",
      timestamp: Time.now.iso8601
    }

    OrderPublisher.publish_order_paid(order_data)

    flash[:success] = "✅ Order ##{order_data[:order_id]} paid! Check console logs."
    redirect_to demo_index_path
  end

  def shipped_order
    order_data = {
      order_id: rand(10000..99999),
      product: "MacBook Pro",
      country: params[:country] || "vn",
      tracking_number: "VN#{rand(100000..999999)}",
      timestamp: Time.now.iso8601
    }

    OrderPublisher.publish_order_shipped(order_data)

    flash[:success] = "✅ Order ##{order_data[:order_id]} shipped! Check console logs."
    redirect_to demo_index_path
  end

  def direct_exchange_demo
    priority = params[:priority] || 'high'
    message = {
      id: rand(1000..9999),
      content: "Priority message: #{priority}",
      timestamp: Time.now.iso8601
    }

    OrderPublisher.publish_with_priority(message, priority)

    flash[:success] = "✅ Published to Direct Exchange with priority: #{priority}"
    redirect_to demo_index_path
  end

  def headers_exchange_demo
    format = params[:format] || 'pdf'
    priority = params[:priority] || 'high'
    size = params[:size] || 'large'

    headers = {
      format: format,
      priority: priority,
      size: size,
      type: 'document'
    }

    message = {
      id: rand(1000..9999),
      content: "Document processing request",
      timestamp: Time.now.iso8601
    }

    OrderPublisher.publish_with_headers(message, headers)

    flash[:success] = "✅ Published to Headers Exchange with: #{headers.inspect}"
    redirect_to demo_index_path
  end

  def stats
    # Get RabbitMQ stats
    @rabbitmq_stats = {
      connected: RabbitMQConfig.connection&.open?,
      exchanges: ['direct', 'fanout', 'topic', 'headers', 'dlx'],
      queues: [
        'inventory.service',
        'accounting.service',
        'vietnam.warehouse',
        'analytics.service',
        'logging.service'
      ]
    }

    # Get Sidekiq stats
    @sidekiq_stats = Sidekiq::Stats.new

    render json: {
      rabbitmq: @rabbitmq_stats,
      sidekiq: {
        processed: @sidekiq_stats.processed,
        failed: @sidekiq_stats.failed,
        enqueued: @sidekiq_stats.enqueued,
        scheduled: @sidekiq_stats.scheduled_size
      }
    }
  end
end
