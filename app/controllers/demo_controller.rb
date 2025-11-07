class DemoController < ApplicationController
  def index; end

  def stats
    sidekiq = Sidekiqs::Gather.call.data
    rabbitmq = RabbitMQs::Gather.call.data

    render json: { sidekiq:, rabbitmq: }
  end
end
