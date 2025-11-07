# app/helpers/home_helper.rb
module HomeHelper
  # Icon constants
  ICONS = {
    rabbitmq: '🐰',
    sidekiq: '⚡',
    agenda: '📋',
    problem: '❌',
    solution: '✅',
    message_queue: '📬',
    message_broker: '📮',
    architecture: '🏗️',
    exchange: '🔀',
    flow: '🔄',
    reliability: '🛡️',
    use_cases: '🎯',
    comparison: '⚖️',
    decision: '🎯',
    thank_you: '🙏',
    user: '👤',
    waiting: '⏳',
    fast: '⚡',
    background: '📬',
    producer: '📤',
    queue: '📬',
    consumer: '⚙️',
    connection: '🔌',
    channel: '📡',
    binding: '🔗',
    direct: '🎯',
    fanout: '📢',
    topic: '⭐',
    headers: '🔖',
    email: '📧',
    image: '🖼️',
    order: '📦',
    paid: '💰',
    shipped: '🚚',
    demo: '🚀',
    docs: '📚'
  }.freeze

  # Agenda items
  AGENDA_ITEMS = [
    { title: "1. Problem & Solution", desc: "Synchronous vs Asynchronous Processing" },
    { title: "2. Message Queue Fundamentals", desc: "Message Queue & Message Broker" },
    { title: "3. RabbitMQ ⭐", desc: "Architecture, Exchange Types, Reliability" },
    { title: "4. Live Demo 🚀", desc: "RabbitMQ + Sneakers implementation" },
    { title: "5. Comparison & Decision", desc: "When to use what" },
    { title: "6. Q&A", desc: "Common questions & answers" }
  ].freeze

  # Problem flow steps
  PROBLEM_FLOW_STEPS = [
    { icon: :user, text: "User submits form" },
    { icon: :waiting, text: "Server creates account", time: "100ms" },
    { icon: :waiting, text: "Server sends welcome email", time: "3-5s" },
    { icon: :waiting, text: "Server resizes avatar", time: "2-3s" },
    { icon: :waiting, text: "Server sends notification", time: "1-2s" }
  ].freeze

  # Problem consequences
  PROBLEM_CONSEQUENCES = [
    "Bad UX → 40% users leave if wait > 3s",
    "Server blocked, can't process other requests",
    "Cannot scale when traffic increases",
    "Single point of failure"
  ].freeze

  # Solution async steps
  SOLUTION_ASYNC_STEPS = [
    { icon: ICONS[:user], text: "User submits form" },
    { icon: ICONS[:fast], text: "Server creates account", time: "100ms" },
    { icon: ICONS[:solution], text: "Server responds immediately", time: "200ms total", highlight: true }
  ].freeze

  # Solution benefits
  SOLUTION_BENEFITS = [
    { icon: :smile, text: "Great UX (response < 300ms)", color: "green" },
    { icon: :unlock, text: "Server not blocked", color: "blue" },
    { icon: :trending_up, text: "Easy to scale (add workers)", color: "purple" },
    { icon: :shield_check, text: "Fault tolerance", color: "orange" },
    { icon: :refresh_cw, text: "Automatic retry on failure", color: "teal" }
  ].freeze

  # Message queue components
  MQ_COMPONENTS = [
    { icon: ICONS[:producer], name: "Producer", desc: "(Rails App)" },
    { icon: ICONS[:queue], name: "Queue", desc: "(Storage)" },
    { icon: ICONS[:consumer], name: "Consumer", desc: "(Worker)" }
  ].freeze

  # Message flow steps
  MESSAGE_FLOW_STEPS = [
    "Producer creates message",
    "Publish to Exchange (with routing key)",
    "Exchange evaluates routing rules",
    "Message routed to Queue(s) based on bindings",
    "Queue persists message (if durable)",
    "Consumer fetches message from Queue",
    "Consumer processes message",
    "Consumer sends ACK back to RabbitMQ",
    "RabbitMQ removes message from Queue"
  ].freeze

  # Architecture components
  ARCH_COMPONENTS = [
    { icon: ICONS[:producer], name: "Producer" },
    { icon: ICONS[:connection], name: "Connection" },
    { icon: ICONS[:channel], name: "Channel" },
    { icon: ICONS[:exchange], name: "Exchange" },
    { icon: ICONS[:binding], name: "Binding" },
    { icon: ICONS[:queue], name: "Queue" },
    { icon: ICONS[:consumer], name: "Consumer" }
  ].freeze

  # Architecture details
  ARCH_DETAILS = [
    { component: "Connection", role: "TCP connection between app and RabbitMQ", importance: "1 app = 1 connection, expensive" },
    { component: "Channel", role: "Virtual connection within Connection", importance: "Lightweight, multiple channels/connection" },
    { component: "Exchange", role: "Routes messages to queues", importance: "Core routing logic" },
    { component: "Binding", role: "Rules linking Exchange → Queue", importance: "Defines routing patterns" },
    { component: "Queue", role: "Buffer storing messages for consumer", importance: "FIFO storage" },
    { component: "Routing Key", role: "Key for routing message", importance: "Pattern matching" }
  ].freeze

  # Exchange types comparison
  EXCHANGE_COMPARISON = [
    { type: "Direct", perf: "⭐⭐⭐⭐⭐", comp: "⭐", flex: "⭐", use: "Simple routing" },
    { type: "Fanout", perf: "⭐⭐⭐⭐⭐", comp: "⭐", flex: "⭐⭐", use: "Broadcasting" },
    { type: "Topic", perf: "⭐⭐⭐", comp: "⭐⭐⭐", flex: "⭐⭐⭐⭐⭐", use: "Event-driven (Most popular)" },
    { type: "Headers", perf: "⭐⭐", comp: "⭐⭐⭐⭐⭐", flex: "⭐⭐⭐⭐", use: "Complex rules (Rarely used)" }
  ].freeze

  # Reliability features
  RELIABILITY_FEATURES = [
    { icon: ICONS[:solution], title: "Acknowledgements (ACK/NACK/REJECT)", desc: "Manual ACK is safe - message kept until ACK. Auto ACK = message lost if consumer crashes." },
    { icon: "💾", title: "Message Durability", desc: "Durable Queue + Persistent Messages = survive RabbitMQ restart" },
    { icon: "📩", title: "Publisher Confirms", desc: "Producer receives confirmation from RabbitMQ, ensures message was accepted" },
    { icon: "💀", title: "Dead Letter Exchange (DLX)", desc: "Queue for undeliverable messages (TTL expired, queue full, consumer reject)" },
    { icon: "⏰", title: "Message TTL & Queue Length", desc: "TTL: Message expires after X seconds. Max Length: Queue limits number of messages" },
    { icon: "🔄", title: "Clustering & Mirroring", desc: "Multiple RabbitMQ nodes, queue mirroring, high availability, no single point of failure" }
  ].freeze

  # Use case patterns
  USE_CASE_PATTERNS = [
    { name: "Work Queue", desc: "Multiple workers compete for jobs, load distribution", use: "Background jobs, task processing" },
    { name: "Pub/Sub", desc: "Broadcast messages to all subscribers", use: "Notifications, logging, cache invalidation" },
    { name: "Routing", desc: "Selective message delivery based on criteria", use: "Log levels, priority routing" },
    { name: "Topics", desc: "Pattern-based routing", use: "Event-driven microservices" },
    { name: "RPC (Request/Reply)", desc: "Synchronous-like behavior over async system", use: "Remote procedure calls" },
    { name: "Priority Queues", desc: "High priority messages processed first", use: "Critical vs normal tasks" }
  ].freeze

  # Common use cases
  COMMON_USE_CASES = [
    "Microservices communication",
    "Event-driven architecture",
    "Decoupling services",
    "Load balancing",
    "Async processing",
    "Data pipeline",
    "Message broadcasting",
    "Priority task handling"
  ].freeze

  # Comparison categories
  COMPARISON_CATEGORIES = [
    {
      title: "Architecture & Protocol",
      items: [
        { aspect: "Type", rabbitmq: "Message Broker (standalone)", sidekiq: "Background job library" },
        { aspect: "Protocol", rabbitmq: "AMQP (standardized)", sidekiq: "Redis protocol" },
        { aspect: "Storage", rabbitmq: "Disk-based + Memory", sidekiq: "In-memory (RAM only)" },
        { aspect: "Language", rabbitmq: "Erlang (highly concurrent)", sidekiq: "Ruby + Redis" }
      ]
    },
    {
      title: "Performance & Scalability",
      items: [
        { aspect: "Throughput", rabbitmq: "~20,000 msg/s", sidekiq: "~100,000+ jobs/s", winner: "sidekiq" },
        { aspect: "Latency", rabbitmq: "~50ms (p99)", sidekiq: "~10ms (p99)", winner: "sidekiq" },
        { aspect: "Memory Usage", rabbitmq: "Medium-High", sidekiq: "Low (thread-based)", winner: "sidekiq" },
        { aspect: "Scaling", rabbitmq: "Horizontal (cluster)", sidekiq: "Horizontal (multiple processes)", winner: "tie" }
      ]
    },
    {
      title: "Routing & Flexibility",
      items: [
        { aspect: "Routing Types", rabbitmq: "4 exchange types", sidekiq: "Queue names only", winner: "rabbitmq" },
        { aspect: "Pattern Matching", rabbitmq: "✅ Wildcards (*, #)", sidekiq: "❌ None", winner: "rabbitmq" },
        { aspect: "Broadcast", rabbitmq: "✅ Fanout exchange", sidekiq: "❌ Manual implementation", winner: "rabbitmq" },
        { aspect: "Topic-based", rabbitmq: "✅ Topic exchange", sidekiq: "❌ Not supported", winner: "rabbitmq" }
      ]
    },
    {
      title: "Reliability & Guarantees",
      items: [
        { aspect: "Persistence", rabbitmq: "✅ Disk-based, durable", sidekiq: "⚠️ Optional (RDB/AOF)", winner: "rabbitmq" },
        { aspect: "Publisher Confirms", rabbitmq: "✅ Built-in", sidekiq: "❌ None", winner: "rabbitmq" },
        { aspect: "Message TTL", rabbitmq: "✅ Per-message or queue", sidekiq: "⚠️ Manual implementation", winner: "rabbitmq" },
        { aspect: "Data Loss Risk", rabbitmq: "Very Low", sidekiq: "Medium (if Redis crashes)", winner: "rabbitmq" }
      ]
    },
    {
      title: "Development & Integration",
      items: [
        { aspect: "Setup Complexity", rabbitmq: "Medium-High", sidekiq: "Very Low", winner: "sidekiq" },
        { aspect: "Learning Curve", rabbitmq: "Steep", sidekiq: "Gentle", winner: "sidekiq" },
        { aspect: "Rails Integration", rabbitmq: "⚠️ Needs Sneakers/Bunny", sidekiq: "✅ Native, seamless", winner: "sidekiq" },
        { aspect: "Multi-language", rabbitmq: "✅ All languages", sidekiq: "❌ Ruby only", winner: "rabbitmq" }
      ]
    },
    {
      title: "Cost & Infrastructure",
      items: [
        { aspect: "RAM Required", rabbitmq: "2-4GB base", sidekiq: "512MB - 2GB", winner: "sidekiq" },
        { aspect: "Monthly Cost", rabbitmq: "~$50-400 (cloud)", sidekiq: "~$15-200 (cloud)", winner: "sidekiq" },
        { aspect: "Maintenance", rabbitmq: "Medium effort", sidekiq: "Low effort", winner: "sidekiq" },
        { aspect: "DevOps Complexity", rabbitmq: "Higher", sidekiq: "Lower", winner: "sidekiq" }
      ]
    }
  ].freeze

  # Summary scores
  SUMMARY_SCORES = [
    { cat: "Performance", rabbitmq: "4/5", sidekiq: "5/5" },
    { cat: "Reliability", rabbitmq: "5/5", sidekiq: "3/5" },
    { cat: "Flexibility", rabbitmq: "5/5", sidekiq: "2/5" },
    { cat: "Ease of Use", rabbitmq: "3/5", sidekiq: "5/5" },
    { cat: "Cost", rabbitmq: "3/5", sidekiq: "5/5" }
  ].freeze

  # Decision matrix
  DECISION_MATRIX = [
    { req: "Rails monolith app", rec: "Sidekiq", reason: "Simple, fast, Rails-optimized" },
    { req: "Microservices (2+ services)", rec: "RabbitMQ", reason: "Inter-service communication" },
    { req: "Multi-language environment", rec: "RabbitMQ", reason: "Language-agnostic" },
    { req: "Complex routing needs", rec: "RabbitMQ", reason: "Topic/Fanout exchanges" },
    { req: "Simple background jobs", rec: "Sidekiq", reason: "Overkill to use RabbitMQ" },
    { req: "Mission-critical data", rec: "RabbitMQ", reason: "Better persistence" },
    { req: "Budget constraints", rec: "Sidekiq", reason: "Cheaper infrastructure" },
    { req: "Need pattern matching", rec: "RabbitMQ", reason: "Wildcards support" },
    { req: "Event-driven architecture", rec: "RabbitMQ", reason: "Pub/Sub patterns" },
    { req: "Quick MVP", rec: "Sidekiq", reason: "Faster setup" },
    { req: "Enterprise scale", rec: "RabbitMQ", reason: "Better for large systems" }
  ].freeze

  # Growth stages
  GROWTH_STAGES = [
    { stage: "Stage 1: MVP / Small App", use: "Sidekiq only", why: "Simple, fast to build" },
    { stage: "Stage 2: Growing App", use: "Sidekiq + Redis", why: "Add more workers, queues" },
    { stage: "Stage 3: Multiple Services Emerge", use: "Add RabbitMQ for service communication", why: "Keep Sidekiq for internal jobs" },
    { stage: "Stage 4: Microservices Architecture", use: "Primary: RabbitMQ for all services", why: "Optional: Sidekiq in Rails services" }
  ].freeze

  # Helper methods
  def icon(name)
    ICONS[name.to_sym] || name.to_s
  end

  def agenda_items
    AGENDA_ITEMS
  end

  def problem_flow_steps
    PROBLEM_FLOW_STEPS
  end

  def solution_async_steps
    SOLUTION_ASYNC_STEPS
  end

  def mq_components
    MQ_COMPONENTS
  end

  def message_flow_steps
    MESSAGE_FLOW_STEPS
  end

  def arch_components
    ARCH_COMPONENTS
  end

  def arch_details
    ARCH_DETAILS
  end

  def exchange_comparison
    EXCHANGE_COMPARISON
  end

  def reliability_features
    RELIABILITY_FEATURES
  end

  def use_case_patterns
    USE_CASE_PATTERNS
  end

  def common_use_cases
    COMMON_USE_CASES
  end

  def comparison_categories
    COMPARISON_CATEGORIES
  end

  def summary_scores
    SUMMARY_SCORES
  end

  def decision_matrix
    DECISION_MATRIX
  end

  def growth_stages
    GROWTH_STAGES
  end

  def problem_consequences
    PROBLEM_CONSEQUENCES
  end

  def solution_benefits
    SOLUTION_BENEFITS
  end
end
