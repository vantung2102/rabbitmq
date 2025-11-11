class EmailJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: 3

  def perform(email)
    puts "================================================"

    puts "[SIDEKIQ][EMAIL JOB] Sending email to #{email}"
    sleep 1

    puts "================================================"
  end
end
