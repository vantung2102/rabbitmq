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

### 4. Xem Console Logs
Tất cả actions sẽ log ra console với format:
```
📤 Published to Topic Exchange: order.created.vn
📦 [INVENTORY] Processing order #12345
💰 [ACCOUNTING] Processing payment for order #12345
📧 [EMAIL] Sending email to customer@example.com
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
