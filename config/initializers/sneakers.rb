# config/initializers/sneakers.rb
require 'sneakers'

Sneakers.configure(
  amqp: ENV.fetch('RABBITMQ_URL', 'amqp://guest:guest@localhost:5672'),
  daemonize: false,
  workers: 4,
  threads: 10,
  prefetch: 10,
  env: Rails.env,
  log: STDOUT,
  pid_path: 'tmp/pids/sneakers.pid',
  timeout_job_after: 60,
  heartbeat: 30,
  hooks: {
    before_fork: -> {
      ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord)
    },
    after_fork: -> {
      ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
    }
  }
)

Sneakers.logger.level = Logger::INFO
