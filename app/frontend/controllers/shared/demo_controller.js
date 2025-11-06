import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['sidekiqResponse', 'rabbitmqResponse'];

  // Sidekiq Demo Functions
  sendSidekiqEmail(event) {
    event.preventDefault();
    const email = document.getElementById('sidekiq-email').value;
    const responseBox = this.sidekiqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Sending email job to Sidekiq...</span>';

    setTimeout(() => {
      const response = {
        success: true,
        job_id: 'jid-' + Math.random().toString(36).substr(2, 9),
        message: 'Email job queued successfully',
        queue: 'default',
        email: email,
        estimated_time: '~3-5 seconds',
        worker: 'EmailWorker',
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }

  processSidekiqImage(event) {
    event.preventDefault();
    const imageUrl = document.getElementById('sidekiq-image').value;
    const responseBox = this.sidekiqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Queueing image processing job...</span>';

    setTimeout(() => {
      const response = {
        success: true,
        job_id: 'jid-' + Math.random().toString(36).substr(2, 9),
        message: 'Image processing job queued',
        queue: 'default',
        image_url: imageUrl,
        estimated_time: '~10-15 seconds',
        worker: 'ImageProcessorWorker',
        operations: ['resize', 'compress', 'watermark'],
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }

  generateSidekiqReport(event) {
    event.preventDefault();
    const reportType = document.getElementById('sidekiq-report').value;
    const responseBox = this.sidekiqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Starting report generation...</span>';

    setTimeout(() => {
      const response = {
        success: true,
        job_id: 'jid-' + Math.random().toString(36).substr(2, 9),
        message: 'Report generation started',
        queue: 'default',
        report_type: reportType,
        estimated_time: '~20-30 seconds',
        worker: 'ReportGeneratorWorker',
        format: 'PDF',
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }

  // RabbitMQ Demo Functions
  createRabbitmqOrder(event) {
    event.preventDefault();
    const customer = document.getElementById('rabbitmq-customer').value;
    const amount = document.getElementById('rabbitmq-amount').value;
    const priority = document.getElementById('rabbitmq-priority').value;
    const responseBox = this.rabbitmqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Publishing order to RabbitMQ Direct Exchange...</span>';

    setTimeout(() => {
      const response = {
        success: true,
        order_id: 'order-' + Math.random().toString(36).substr(2, 9),
        customer: customer,
        amount: '$' + amount,
        message: 'Order published to RabbitMQ',
        exchange: 'orders.direct',
        exchange_type: 'Direct',
        routing_key: 'order.' + priority,
        queues: ['order_processing', 'inventory_update', 'analytics'],
        note: 'Routed based on priority: ' + priority,
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }

  broadcastRabbitmqNotification(event) {
    event.preventDefault();
    const message = document.getElementById('rabbitmq-notification').value;
    const type = document.getElementById('rabbitmq-type').value;
    const responseBox = this.rabbitmqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Broadcasting to all queues via Fanout Exchange...</span>';

    setTimeout(() => {
      const response = {
        success: true,
        notification_id: 'notif-' + Math.random().toString(36).substr(2, 9),
        message: message,
        type: type,
        exchange: 'notifications.fanout',
        exchange_type: 'Fanout',
        routing_key: '(ignored for fanout)',
        queues: ['web_notifications', 'mobile_push', 'email_notifications', 'sms_queue'],
        note: 'All queues receive this message (broadcast)',
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }

  publishRabbitmqEvent(event) {
    event.preventDefault();
    const eventType = document.getElementById('rabbitmq-event-type').value;
    const action = document.getElementById('rabbitmq-action').value;
    const region = document.getElementById('rabbitmq-region').value;
    const responseBox = this.rabbitmqResponseTarget;

    responseBox.innerHTML = '<span class="text-yellow-500">⏳ Publishing event with Topic routing...</span>';

    setTimeout(() => {
      const routingKey = eventType + '.' + action + '.' + region;
      const matchedQueues = [];

      if (eventType === 'order') matchedQueues.push('order_processing', 'analytics');
      if (action === 'created') matchedQueues.push('audit_log');
      if (region === 'vn') matchedQueues.push('vietnam_regional');
      if (eventType === 'user') matchedQueues.push('user_service');

      const response = {
        success: true,
        event_id: 'evt-' + Math.random().toString(36).substr(2, 9),
        event_type: eventType,
        action: action,
        region: region,
        message: 'Event published with topic routing',
        exchange: 'events.topic',
        exchange_type: 'Topic',
        routing_key: routingKey,
        pattern_matching: {
          wildcards: '* = 1 word, # = 0+ words',
          examples: [eventType + '.#', '*.' + action + '.*', '#.' + region]
        },
        matched_queues: matchedQueues.length > 0 ? matchedQueues : ['analytics'],
        timestamp: new Date().toISOString()
      };
      responseBox.innerHTML = '<pre class="text-green-500">' + JSON.stringify(response, null, 2) + '</pre>';
    }, 500);
  }
}
