# 🚀 Hướng Dẫn Demo: RabbitMQ vs Sidekiq

## 📋 Mục Lục
1. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
2. [Cài Đặt & Khởi Động](#cài-đặt--khởi-động)
3. [Kiểm Tra Kết Nối](#kiểm-tra-kết-nối)
4. [Hướng Dẫn Demo](#hướng-dẫn-demo)
5. [Troubleshooting](#troubleshooting)

---

## 🔧 Yêu Cầu Hệ Thống

### Dependencies Cần Có:
1. **Ruby** >= 3.0
2. **Rails** >= 8.0
3. **PostgreSQL** (đang chạy)
4. **Redis** (đang chạy) - cho Sidekiq
5. **RabbitMQ** (đang chạy) - cho RabbitMQ demo

### Services Cần Chạy:
```bash
# 1. PostgreSQL
brew services start postgresql@14
# hoặc
sudo service postgresql start

# 2. Redis
brew services start redis
# hoặc
redis-server

# 3. RabbitMQ
brew services start rabbitmq
# hoặc
rabbitmq-server
```

---

## 🚀 Cài Đặt & Khởi Động

### Bước 1: Cài Đặt Dependencies
```bash
# Install gems
bundle install

# Install frontend dependencies
npm install
# hoặc
yarn install
```

### Bước 2: Setup Database
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate
```

### Bước 3: Cấu Hình Environment Variables
Tạo file `.env` hoặc export các biến môi trường:

```bash
# Redis (cho Sidekiq)
export REDIS_URL=redis://localhost:6379/1

# RabbitMQ
export RABBITMQ_HOST=localhost
export RABBITMQ_PORT=5672
export RABBITMQ_USER=guest
export RABBITMQ_PASS=guest
export RABBITMQ_URL=amqp://guest:guest@localhost:5672
```

### Bước 4: Khởi Động Services

**Terminal 1: Rails Server**
```bash
rails server
# hoặc
rails s
```

**Terminal 2: Sidekiq Workers**
```bash
bundle exec sidekiq
```

**Terminal 3: RabbitMQ Consumers (Sneakers)**
```bash
bin/sneakers
```

**Lưu ý:** Script `bin/sneakers` sẽ tự động:
- Tìm tất cả files `*_consumer.rb` trong `app/consumers/`
- Load tất cả consumers
- Chạy Sneakers với tất cả consumers đã tìm được
- Bạn không cần phải list từng consumer nữa!

**Terminal 4: Vite Dev Server (nếu cần hot reload)**
```bash
bin/vite dev
```

---

## ✅ Kiểm Tra Kết Nối

### 1. Kiểm Tra RabbitMQ
```bash
# Kiểm tra RabbitMQ đang chạy
rabbitmqctl status

# Mở Management UI
# http://localhost:15672
# Username: guest
# Password: guest
```

### 2. Kiểm Tra Redis
```bash
# Kiểm tra Redis đang chạy
redis-cli ping
# Nên trả về: PONG
```

### 3. Kiểm Tra Sidekiq Web UI
Truy cập: `http://localhost:3000/sidekiq`

### 4. Kiểm Tra Demo Page
Truy cập: `http://localhost:3000/demo`

---

## 🎯 Hướng Dẫn Demo

### Demo Flow:

#### **Phần 1: Sidekiq Demo** ⚡

1. **Send Email Job**
   - Điền email address
   - Click "📧 Send Email Job"
   - **Kết quả mong đợi:**
     - Job được queue vào Sidekiq
     - Xem trong Sidekiq Web UI (`/sidekiq`)
     - EmailWorker sẽ xử lý job
     - Console log: `📧 [EMAIL] Sending email...`

2. **Process Image**
   - Điền image URL
   - Click "🖼️ Process Image"
   - **Kết quả mong đợi:**
     - ImageProcessingWorker xử lý
     - Console log: `🖼️ [IMAGE] Processing...`

#### **Phần 2: RabbitMQ Demo** 🐰

1. **Create Order (Topic Exchange)**
   - Điền Product, Amount, Country
   - Click "📦 Create Order"
   - **Kết quả mong đợi:**
     - Message được publish với routing key: `order.created.{country}`
     - **Topic Exchange routing:**
       - `order.created.vn` → `inventory.service`, `vietnam.warehouse`, `analytics.service`
       - `order.created.us` → `inventory.service`, `analytics.service`
     - **Fanout Exchange:** Broadcast đến tất cả queues
     - Console logs:
       ```
       📤 Published to Topic Exchange: order.created.vn
       📤 Broadcasted to Fanout Exchange
       📦 [INVENTORY] Processing order...
       📊 [ANALYTICS] Tracking order...
       🇻🇳 [VIETNAM WAREHOUSE] Processing...
       📝 [LOGGING] Logging event...
       ```

2. **Paid Order**
   - Chọn Country
   - Click "💰 Paid Order"
   - **Kết quả mong đợi:**
     - Routing key: `order.paid.{country}`
     - Matches: `order.paid.#` → `accounting.service`
     - Console log: `💰 [ACCOUNTING] Processing payment...`

3. **Shipped Order**
   - Chọn Country
   - Click "🚚 Shipped Order"
   - **Kết quả mong đợi:**
     - Routing key: `order.shipped.{country}`
     - Console log: `🚚 [SHIPPING] Processing shipment...`

4. **Direct Exchange Demo**
   - Chọn Priority (High/Medium/Low)
   - Click "🎯 Direct Exchange"
   - **Kết quả mong đợi:**
     - Routing key: `priority.{priority}`
     - Exact match routing
     - Console log: `📤 Published to Direct Exchange: priority.high`

5. **Headers Exchange Demo**
   - Chọn Format, Priority, Size
   - Click "🔖 Headers Exchange"
   - **Kết quả mong đợi:**
     - Routing dựa trên headers
     - Console log: `📤 Published to Headers Exchange with: {...}`

---

## 🔍 Monitoring & Debugging

### 1. Xem Logs Rails
```bash
# Xem logs real-time
tail -f log/development.log

# Hoặc trong Rails console
rails console
# Xem RabbitMQ connection
RabbitMQConfig.connection&.open?
```

### 2. Xem Sidekiq Jobs
- Truy cập: `http://localhost:3000/sidekiq`
- Xem:
  - **Processed**: Số jobs đã xử lý
  - **Failed**: Số jobs thất bại
  - **Enqueued**: Số jobs đang chờ
  - **Retries**: Jobs đang retry

### 3. Xem RabbitMQ Management UI
- Truy cập: `http://localhost:15672`
- Login: `guest` / `guest`
- Xem:
  - **Connections**: Số connections
  - **Channels**: Số channels
  - **Exchanges**: Các exchanges (demo.direct, demo.fanout, demo.topic, demo.headers)
  - **Queues**: Các queues và số messages
  - **Message Rates**: Tốc độ publish/consume

---

## 🔍 Hướng Dẫn Chi Tiết: Kiểm Tra RabbitMQ

### 1. RabbitMQ Management UI (Web Interface)

#### Truy Cập:
```
URL: http://localhost:15672
Username: guest
Password: guest
```

#### Các Tab Quan Trọng:

**A. Overview Tab (Trang chủ)**
- Xem tổng quan: Connections, Channels, Exchanges, Queues
- Message rates: Publish rate, Delivery rate
- Node info: Memory, Disk usage

**B. Connections Tab**
- Xem tất cả connections đang active
- Kiểm tra connection từ Rails app
- Xem connection details: Channels, State, Protocol

**C. Channels Tab**
- Xem tất cả channels
- Mỗi connection có thể có nhiều channels
- Xem channel details: Prefetch, Unacked messages

**D. Exchanges Tab** ⭐ (Quan trọng nhất cho demo)
- Xem tất cả exchanges:
  - `demo.direct` - Direct Exchange
  - `demo.fanout` - Fanout Exchange
  - `demo.topic` - Topic Exchange (MOST USED)
  - `demo.headers` - Headers Exchange
  - `demo.dlx` - Dead Letter Exchange
- Click vào exchange để xem:
  - **Bindings**: Queues nào đang bind với exchange này
  - **Routing keys**: Pattern matching rules
  - **Message rates**: Publish/consume rates

**E. Queues Tab** ⭐ (Quan trọng cho demo)
- Xem tất cả queues:
  - `inventory.service` - Inventory consumer
  - `accounting.service` - Accounting consumer
  - `vietnam.warehouse` - Vietnam warehouse consumer
  - `analytics.service` - Analytics consumer
  - `logging.service` - Logging consumer
- Click vào queue để xem:
  - **Messages**: Số messages đang chờ (Ready, Unacked)
  - **Bindings**: Exchange nào bind với queue này
  - **Routing key**: Pattern matching
  - **Consumers**: Số consumers đang listen
  - **Message rates**: Publish/consume rates
  - **Get messages**: Test consume messages (Preview)

**F. Admin Tab**
- User management
- Virtual hosts
- Policies

#### Cách Kiểm Tra Sau Khi Publish Message:

1. **Sau khi click "📦 Create Order":**
   - Vào **Exchanges** tab → Click `demo.topic`
   - Xem **Bindings**: Sẽ thấy các queues bind với routing keys:
     - `inventory.service` ← `order.created.*`
     - `vietnam.warehouse` ← `#.vn`
     - `analytics.service` ← `order.*`
   - Xem **Message rates**: Publish rate sẽ tăng
   - Vào **Queues** tab → Click từng queue:
     - `inventory.service`: Messages sẽ tăng lên
     - `vietnam.warehouse`: Messages sẽ tăng lên (nếu country = vn)
     - `analytics.service`: Messages sẽ tăng lên
   - Vào **Exchanges** tab → Click `demo.fanout`
   - Xem **Bindings**: Tất cả queues đều nhận message (broadcast)

2. **Sau khi click "💰 Paid Order":**
   - Vào **Exchanges** tab → Click `demo.topic`
   - Xem routing key: `order.paid.vn` hoặc `order.paid.us`
   - Vào **Queues** tab → Click `accounting.service`
   - Xem messages: Sẽ tăng lên (vì binding `order.paid.#`)

3. **Sau khi click "🎯 Direct Exchange":**
   - Vào **Exchanges** tab → Click `demo.direct`
   - Xem **Bindings**: Queues với exact match routing keys
   - Routing keys: `priority.high`, `priority.medium`, `priority.low`

4. **Sau khi click "🔖 Headers Exchange":**
   - Vào **Exchanges** tab → Click `demo.headers`
   - Xem **Bindings**: Queues với header matching rules
   - Headers: `format`, `priority`, `size`

#### Cách Xem Messages Trong Queue:

1. Vào **Queues** tab
2. Click vào queue name (ví dụ: `inventory.service`)
3. Scroll xuống phần **Get messages**
4. Click **Get Message(s)** để preview message
5. Xem message content: JSON format với order data

#### Cách Monitor Real-time:

1. Vào **Queues** tab
2. Click vào queue
3. Xem **Message rates** chart (real-time)
4. Xem **Ready** và **Unacked** messages
5. Nếu messages giảm → Consumers đang xử lý
6. Nếu messages tăng → Consumers không chạy hoặc chậm

---

### 2. RabbitMQ Command Line (rabbitmqctl)

#### Kiểm Tra Status:
```bash
# Kiểm tra RabbitMQ đang chạy
rabbitmqctl status

# Output sẽ hiển thị:
# - Node name
# - Uptime
# - Memory usage
# - Disk usage
# - Erlang version
```

#### Xem Tất Cả Queues:
```bash
# List tất cả queues
rabbitmqctl list_queues name messages consumers

# Output:
# inventory.service    5    1
# accounting.service   2    1
# vietnam.warehouse    3    1
# analytics.service    4    1
# logging.service      6    1
```

#### Xem Tất Cả Exchanges:
```bash
# List tất cả exchanges
rabbitmqctl list_exchanges name type

# Output:
# demo.direct    direct
# demo.fanout    fanout
# demo.topic     topic
# demo.headers   headers
# demo.dlx       fanout
```

#### Xem Bindings (Routing Rules):
```bash
# Xem bindings của exchange
rabbitmqctl list_bindings

# Hoặc xem bindings của specific exchange
rabbitmqctl list_bindings source_name source_kind destination_name destination_kind routing_key

# Ví dụ: Xem bindings của demo.topic
rabbitmqctl list_bindings demo.topic exchange

# Output:
# demo.topic    exchange    inventory.service    queue    order.created.*
# demo.topic    exchange    vietnam.warehouse    queue    #.vn
# demo.topic    exchange    accounting.service   queue    order.paid.#
```

#### Xem Connections:
```bash
# List tất cả connections
rabbitmqctl list_connections name state

# Output:
# <connection_name>    running
```

#### Xem Channels:
```bash
# List tất cả channels
rabbitmqctl list_channels name connection number

# Output:
# <channel_name>    <connection_name>    1
```

#### Xem Consumers:
```bash
# List tất cả consumers
rabbitmqctl list_consumers queue_name

# Hoặc xem consumers của specific queue
rabbitmqctl list_consumers inventory.service

# Output:
# queue_name            channel_details    consumer_tag    ack_required
# inventory.service     <channel>          <tag>           true
```

#### Purge Queue (Xóa tất cả messages trong queue):
```bash
# Xóa messages trong queue (cẩn thận!)
rabbitmqctl purge_queue inventory.service
```

#### Delete Queue:
```bash
# Xóa queue (cẩn thận!)
rabbitmqctl delete_queue inventory.service
```

---

### 3. Kiểm Tra Từ Rails Console

#### Mở Rails Console:
```bash
rails console
# hoặc
rails c
```

#### Kiểm Tra Connection:
```ruby
# Kiểm tra RabbitMQ connection
RabbitMQConfig.connection&.open?
# => true (nếu connected) hoặc false/nil (nếu không connected)

# Xem connection details
RabbitMQConfig.connection
# => #<Bunny::Session:...>

# Xem channel
RabbitMQConfig.channel
# => #<Bunny::Channel:...>
```

#### Kiểm Tra Exchanges:
```ruby
# Kiểm tra exchanges
RabbitMQConfig.topic_exchange
# => #<Bunny::Exchange:...>

RabbitMQConfig.fanout_exchange
RabbitMQConfig.direct_exchange
RabbitMQConfig.headers_exchange
```

#### Test Publish Message:
```ruby
# Test publish message
order_data = {
  order_id: 12345,
  product: "MacBook Pro",
  amount: 2999,
  country: "vn",
  timestamp: Time.now.iso8601
}

OrderPublisher.publish_order_created(order_data)
# => Message được publish thành công
```

#### Kiểm Tra Queue Messages:
```ruby
# Lấy channel
channel = RabbitMQConfig.channel

# Declare queue (passive mode - chỉ kiểm tra, không tạo mới)
queue = channel.queue('inventory.service', passive: true)

# Xem số messages
queue.message_count
# => 5 (số messages đang chờ)

# Xem consumers
queue.consumer_count
# => 1 (số consumers đang listen)
```

---

### 4. Checklist Kiểm Tra RabbitMQ Trước Demo

#### Trước Khi Demo:
- [ ] RabbitMQ đang chạy: `rabbitmqctl status`
- [ ] Management UI accessible: `http://localhost:15672`
- [ ] Login thành công với `guest/guest`
- [ ] Exchanges đã được tạo:
  - [ ] `demo.direct`
  - [ ] `demo.fanout`
  - [ ] `demo.topic`
  - [ ] `demo.headers`
- [ ] Queues đã được tạo (sau khi start Sneakers):
  - [ ] `inventory.service`
  - [ ] `accounting.service`
  - [ ] `vietnam.warehouse`
  - [ ] `analytics.service`
  - [ ] `logging.service`
- [ ] Consumers đang listen (trong Queues tab, xem "Consumers" > 0)
- [ ] Bindings đã đúng:
  - [ ] `demo.topic` → `inventory.service` với `order.created.*`
  - [ ] `demo.topic` → `vietnam.warehouse` với `#.vn`
  - [ ] `demo.topic` → `accounting.service` với `order.paid.#`
  - [ ] `demo.fanout` → tất cả queues (broadcast)

#### Trong Khi Demo:
- [ ] Sau khi publish message, messages tăng trong queues
- [ ] Messages giảm khi consumers xử lý
- [ ] Message rates hiển thị trong Management UI
- [ ] Console logs hiển thị consumer processing

#### Sau Khi Demo:
- [ ] Kiểm tra messages đã được consume hết
- [ ] Không có messages bị stuck trong queues
- [ ] Consumers vẫn đang listen

---

### 5. Debug RabbitMQ Issues

#### Vấn Đề: Messages Không Được Route

**Kiểm tra:**
1. Exchange đã được tạo chưa?
   ```bash
   rabbitmqctl list_exchanges | grep demo
   ```

2. Queue đã được tạo chưa?
   ```bash
   rabbitmqctl list_queues | grep inventory
   ```

3. Binding đã đúng chưa?
   ```bash
   rabbitmqctl list_bindings | grep demo.topic
   ```

4. Routing key có match pattern không?
   - `order.created.vn` → `order.created.*` ✅
   - `order.created.vn` → `order.created.us` ❌

#### Vấn Đề: Messages Không Được Consume

**Kiểm tra:**
1. Consumers đang chạy chưa?
   ```bash
   rabbitmqctl list_consumers inventory.service
   ```

2. Sneakers workers đang chạy chưa?
   ```bash
   ps aux | grep sneakers
   ```

3. Queue có messages không?
   ```bash
   rabbitmqctl list_queues name messages
   ```

4. Consumers có bị error không?
   - Xem console logs của Sneakers workers

#### Vấn Đề: Connection Failed

**Kiểm tra:**
1. RabbitMQ đang chạy?
   ```bash
   rabbitmqctl status
   ```

2. Port 5672 có bị block không?
   ```bash
   lsof -i :5672
   ```

3. Credentials đúng chưa?
   - Check `.env` hoặc environment variables

4. Firewall có block không?
   ```bash
   telnet localhost 5672
   ```

---

### 6. Quick Reference Commands

#### Trước Demo:
```bash
# 1. Check RabbitMQ status
rabbitmqctl status

# 2. List exchanges
rabbitmqctl list_exchanges name type | grep demo

# 3. List queues
rabbitmqctl list_queues name messages consumers | grep -E "(inventory|accounting|vietnam|analytics|logging)"

# 4. List bindings
rabbitmqctl list_bindings | grep demo.topic
```

#### Trong Demo:
```bash
# Monitor queues real-time
watch -n 1 'rabbitmqctl list_queues name messages consumers'

# Xem message rates
# (Sử dụng Management UI: http://localhost:15672)
```

#### Sau Demo:
```bash
# Check messages còn lại
rabbitmqctl list_queues name messages

# Purge queues nếu cần (cẩn thận!)
rabbitmqctl purge_queue inventory.service
```

---

## 🐛 Troubleshooting

### Lỗi 1: RabbitMQ Connection Failed
```
❌ RabbitMQ connection failed: ...
```

**Giải pháp:**
1. Kiểm tra RabbitMQ đang chạy:
   ```bash
   rabbitmqctl status
   ```
2. Kiểm tra credentials trong `.env` hoặc environment variables
3. Kiểm tra port 5672 không bị block
4. Restart RabbitMQ:
   ```bash
   brew services restart rabbitmq
   ```

### Lỗi 2: Redis Connection Failed
```
Redis::CannotConnectError
```

**Giải pháp:**
1. Kiểm tra Redis đang chạy:
   ```bash
   redis-cli ping
   ```
2. Kiểm tra REDIS_URL trong environment
3. Restart Redis:
   ```bash
   brew services restart redis
   ```

### Lỗi 3: Sidekiq Workers Không Chạy
**Giải pháp:**
1. Đảm bảo đã start Sidekiq:
   ```bash
   bundle exec sidekiq
   ```
2. Kiểm tra Sidekiq Web UI: `http://localhost:3000/sidekiq`
3. Kiểm tra Redis connection

### Lỗi 4: Sneakers Consumers Không Nhận Messages
**Giải pháp:**
1. Đảm bảo đã start Sneakers workers:
   ```bash
   # Cách đơn giản nhất
   bin/sneakers

   # Hoặc
   RAILS_ENV=development bundle exec sneakers work AccountingConsumer InventoryConsumer VietnamWarehouseConsumer AnalyticsConsumer LoggingConsumer
   ```
2. Kiểm tra RabbitMQ connection:
   ```bash
   rabbitmqctl status
   ```
3. Kiểm tra queues đã được bind đúng chưa trong Management UI (`http://localhost:15672`)
4. Xem logs của Sneakers workers - sẽ hiển thị connection status
5. Nếu gặp lỗi "Missing workers", đảm bảo Rails environment đã được load:
   ```bash
   RAILS_ENV=development bundle exec rails runner "puts AccountingConsumer"
   ```

### Lỗi 5: Messages Không Được Route Đúng
**Giải pháp:**
1. Kiểm tra routing keys trong RabbitMQ Management UI
2. Kiểm tra bindings của queues
3. Xem logs để debug routing logic
4. Kiểm tra exchange types đã đúng chưa

### Lỗi 6: Workers Không Tìm Thấy
```
uninitialized constant EmailWorker
```

**Giải pháp:**
1. Kiểm tra file `app/workers/email_worker.rb` tồn tại
2. Restart Rails server
3. Restart Sidekiq workers

---

## 📝 Checklist Trước Khi Demo

- [ ] PostgreSQL đang chạy
- [ ] Redis đang chạy (`redis-cli ping` → PONG)
- [ ] RabbitMQ đang chạy (`rabbitmqctl status`)
- [ ] Rails server đang chạy (`rails s`)
- [ ] Sidekiq workers đang chạy (`bundle exec sidekiq`)
- [ ] Sneakers consumers đang chạy
- [ ] Có thể truy cập `http://localhost:3000/demo`
- [ ] Có thể truy cập `http://localhost:3000/sidekiq`
- [ ] Có thể truy cập `http://localhost:15672` (RabbitMQ Management)
- [ ] Console logs đang hiển thị
- [ ] Test tạo order thành công

---

## 🎬 Demo Script

### Opening (30 giây)
1. Giới thiệu trang demo: `http://localhost:3000/demo`
2. Giải thích 2 phần: Sidekiq (trái) và RabbitMQ (phải)

### Sidekiq Demo (2 phút)
1. **Send Email Job**
   - Click "📧 Send Email Job"
   - Show Sidekiq Web UI: jobs đang queue
   - Show console: EmailWorker đang xử lý
   - Giải thích: Simple, fast, Rails-native

2. **Process Image**
   - Click "🖼️ Process Image"
   - Show jobs trong queue
   - Giải thích: Background processing

### RabbitMQ Demo (5 phút)
1. **Create Order (Topic Exchange)**
   - Điền form: Product="MacBook Pro", Amount=2999, Country="Vietnam"
   - Click "📦 Create Order"
   - **Show RabbitMQ Management UI:**
     - Exchanges: `demo.topic`, `demo.fanout`
     - Queues: `inventory.service`, `vietnam.warehouse`, `analytics.service`
     - Messages đang được route
   - **Show Console Logs:**
     - Multiple consumers đang xử lý
     - Pattern matching: `order.created.*` → multiple queues
   - **Giải thích:**
     - Topic Exchange: Pattern-based routing
     - Fanout Exchange: Broadcast to all
     - Multiple services nhận cùng 1 message

2. **Paid Order**
   - Click "💰 Paid Order"
   - Show: `order.paid.#` → `accounting.service`
   - Giải thích: Wildcard routing

3. **Direct Exchange**
   - Chọn Priority="High"
   - Click "🎯 Direct Exchange"
   - Giải thích: Exact match routing

4. **Headers Exchange**
   - Chọn Format="PDF", Priority="High"
   - Click "🔖 Headers Exchange"
   - Giải thích: Content-based routing

### Comparison (1 phút)
- **Sidekiq:** Simple, fast, Rails-only
- **RabbitMQ:** Complex routing, multi-language, microservices

### Q&A (2 phút)

---

## 🔗 Useful Links

- **Demo Page:** http://localhost:3000/demo
- **Sidekiq Web UI:** http://localhost:3000/sidekiq
- **RabbitMQ Management:** http://localhost:15672
- **Home Page:** http://localhost:3000

---

## 📞 Support

Nếu gặp vấn đề, kiểm tra:
1. Logs: `tail -f log/development.log`
2. RabbitMQ Management UI
3. Sidekiq Web UI
4. Console output của workers

---

**Chúc bạn demo thành công! 🎉**
