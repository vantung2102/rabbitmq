# app/controllers/rabbitmq_controller.rb
class RabbitmqController < ApplicationController
  layout 'application'

  def create_order
    order_data = {
      order_id: rand(10000..99999),
      product: params[:product] || "MacBook Pro",
      amount: params[:amount] || 2999,
      country: params[:country] || "vn",
      customer_email: params[:email] || "customer@example.com",
      timestamp: Time.now.iso8601
    }

    # RabbitMQ - Publish to Topic Exchange and Fanout Exchange
    OrderPublisher.publish_order_created(order_data)

    flash[:success] = "✅ Order ##{order_data[:order_id]} published to RabbitMQ! Check console logs and RabbitMQ Management UI."
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to publish order: #{e.message}"
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

    flash[:success] = "✅ Order ##{order_data[:order_id]} paid! Published to RabbitMQ. Check console logs."
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to publish paid order: #{e.message}"
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

    flash[:success] = "✅ Order ##{order_data[:order_id]} shipped! Published to RabbitMQ. Check console logs."
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to publish shipped order: #{e.message}"
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

    flash[:success] = "✅ Published to Direct Exchange with priority: #{priority}. Check console logs."
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to publish with priority: #{e.message}"
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

    flash[:success] = "✅ Published to Headers Exchange with: #{headers.inspect}. Check console logs."
    redirect_to demo_index_path
  rescue => e
    flash[:error] = "❌ Failed to publish with headers: #{e.message}"
    redirect_to demo_index_path
  end
end
