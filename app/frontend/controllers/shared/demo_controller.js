import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['sidekiqResponse', 'rabbitmqResponse', 'sidekiqProcessed', 'sidekiqWorkers', 'sidekiqFailed', 'sidekiqLatency', 'rabbitmqMessages', 'rabbitmqConnections', 'rabbitmqQueues', 'rabbitmqLatency'];

  connect() {
    this.updateStats();
    this.statsInterval = setInterval(() => this.updateStats(), 3000);
    this.handleFlashMessages();
    this.setupFormListeners();
  }

  disconnect() {
    if (this.statsInterval) {
      clearInterval(this.statsInterval);
    }
  }

  formatNumber(num) {
    if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M';
    if (num >= 1000) return (num / 1000).toFixed(1) + 'K';
    return num.toString();
  }

  formatLatency(ms) {
    if (ms >= 1000) return (ms / 1000).toFixed(1) + 's';
    return ms + 'ms';
  }

  async updateStats() {
    try {
      const response = await fetch('/demo/stats');
      const data = await response.json();

      if (data.sidekiq) {
        const sidekiq = data.sidekiq;
        const processedEl = document.getElementById('sidekiq-processed');
        const workersEl = document.getElementById('sidekiq-workers');
        const failedEl = document.getElementById('sidekiq-failed');
        const latencyEl = document.getElementById('sidekiq-latency');

        if (processedEl) processedEl.textContent = this.formatNumber(sidekiq.processed || 0);
        if (workersEl) workersEl.textContent = sidekiq.workers || 0;
        if (failedEl) failedEl.textContent = this.formatNumber(sidekiq.failed || 0);
        if (latencyEl) latencyEl.textContent = this.formatLatency(sidekiq.latency || 0);
      }

      if (data.rabbitmq) {
        const rabbitmq = data.rabbitmq;
        const messagesEl = document.getElementById('rabbitmq-messages');
        const connectionsEl = document.getElementById('rabbitmq-connections');
        const queuesEl = document.getElementById('rabbitmq-queues');
        const latencyEl = document.getElementById('rabbitmq-latency');

        if (messagesEl) messagesEl.textContent = this.formatNumber(rabbitmq.messages || 0);
        if (connectionsEl) {
          connectionsEl.textContent = rabbitmq.connections || 0;
          if (rabbitmq.connected) {
            connectionsEl.classList.remove('text-red-500');
            connectionsEl.classList.add('text-green-500');
          } else {
            connectionsEl.classList.remove('text-green-500');
            connectionsEl.classList.add('text-red-500');
          }
        }
        if (queuesEl) queuesEl.textContent = rabbitmq.queues || 5;
        if (latencyEl) latencyEl.textContent = this.formatLatency(rabbitmq.latency || 0);
      }
    } catch (err) {
      console.error('Error loading stats:', err);
      const processedEl = document.getElementById('sidekiq-processed');
      const messagesEl = document.getElementById('rabbitmq-messages');
      if (processedEl) processedEl.textContent = '?';
      if (messagesEl) messagesEl.textContent = '?';
    }
  }

  updateSidekiqResponse(message, type = 'info') {
    if (!this.hasSidekiqResponseTarget) return;

    const timestamp = new Date().toLocaleTimeString();
    const color = type === 'success' ? 'text-green-600' : type === 'error' ? 'text-red-600' : 'text-blue-600';

    const currentContent = this.sidekiqResponseTarget.textContent;
    const newEntry = `[${timestamp}] ${message}`;

    const lines = currentContent.split('\n').filter(line => line.trim());
    const activityLines = lines.filter(line => line.includes('[') && line.includes(']'));
    activityLines.push(newEntry);
    const recentActivity = activityLines.slice(-10).join('\n');

    this.sidekiqResponseTarget.innerHTML = `<span class="text-gray-800 font-semibold">📋 Sidekiq Activity Log</span>\n\n<span class="${color}">${recentActivity}</span>\n\n<span class="text-gray-600 text-xs">💡 Check /sidekiq for detailed job status</span>`;
  }

  updateRabbitmqResponse(message, type = 'info') {
    if (!this.hasRabbitmqResponseTarget) return;

    const timestamp = new Date().toLocaleTimeString();
    const color = type === 'success' ? 'text-green-600' : type === 'error' ? 'text-red-600' : 'text-blue-600';

    const currentContent = this.rabbitmqResponseTarget.textContent;
    const newEntry = `[${timestamp}] ${message}`;

    const lines = currentContent.split('\n').filter(line => line.trim());
    const activityLines = lines.filter(line => line.includes('[') && line.includes(']'));
    activityLines.push(newEntry);
    const recentActivity = activityLines.slice(-10).join('\n');

    this.rabbitmqResponseTarget.innerHTML = `<span class="text-gray-800 font-semibold">📋 RabbitMQ Activity Log</span>\n\n<span class="${color}">${recentActivity}</span>\n\n<span class="text-gray-600 text-xs">💡 Check console logs for routing details</span>`;
  }

  handleFlashMessages() {
    const successFlash = document.querySelector('.alert-success');
    const errorFlash = document.querySelector('.alert-error');

    if (successFlash) {
      const message = successFlash.textContent.trim();
      if (message.includes('Email') || message.includes('Image')) {
        this.updateSidekiqResponse(message, 'success');
      } else if (message.includes('Order') || message.includes('Exchange') || message.includes('Published')) {
        this.updateRabbitmqResponse(message, 'success');
      }
    }

    if (errorFlash) {
      const message = errorFlash.textContent.trim();
      if (message.includes('Sidekiq') || message.includes('Email') || message.includes('Image')) {
        this.updateSidekiqResponse(message, 'error');
      } else {
        this.updateRabbitmqResponse(message, 'error');
      }
    }
  }

  setupFormListeners() {
    this.element.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', (e) => {
        const formAction = form.action;
        const submitButton = form.querySelector('input[type="submit"]');
        const buttonText = submitButton ? submitButton.value : '';

        if (formAction.includes('/sidekiq/')) {
          this.updateSidekiqResponse(`⏳ Queuing job: ${buttonText}...`, 'info');
        } else if (formAction.includes('/rabbitmq/')) {
          this.updateRabbitmqResponse(`⏳ Publishing message: ${buttonText}...`, 'info');
        }
      });
    });
  }
}
