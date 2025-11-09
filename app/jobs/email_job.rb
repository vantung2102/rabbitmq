class EmailJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(email)
    puts "Sending email to #{email}"
    sleep 5
    puts "Email sent to #{email}"
  end
end
