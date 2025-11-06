# lib/sneakers_workers.rb
# This file is required by Sneakers to load all consumers
# It will be loaded when running: bundle exec sneakers work ... --require lib/sneakers_workers

# Determine Rails root (this file is in lib/, so go up one level)
rails_root = File.expand_path('..', __dir__)

# Load Rails environment
require File.join(rails_root, 'config', 'environment')

# Auto-discover and require all consumers
consumers_dir = File.join(rails_root, 'app', 'consumers')
consumer_files = Dir.glob(File.join(consumers_dir, '*_consumer.rb')).sort

consumer_files.each do |file|
  require file
end
