class OrdersController < ApplicationController
  def logger
    response = Loggers::Create.call(params)

    render_response(response)
  end

  def create
    response = Orders::Create.call(params)

    render_response(response)
  end

  def payment
    response = Orders::Pay.call(params)

    render_response(response)
  end

  def shipping
    response = Orders::Ship.call(params)

    render_response(response)
  end

  def export
    response = Orders::Export.call(params)

    render_response(response)
  end

  private

  def render_response(response)
    if response.success?
      flash[:success] = response.data[:message]
    else
      flash[:error] = response.errors[:message]
    end

    redirect_to demo_index_path
  end
end
