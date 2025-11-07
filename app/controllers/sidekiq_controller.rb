class SidekiqController < ApplicationController
  def send_email
    Sidekiqs::Create.call(:email, params[:email])

    redirect_to demo_index_path
  end

  def process_image
    Sidekiqs::Create.call(:image, params[:image_url])

    redirect_to demo_index_path
  end
end
