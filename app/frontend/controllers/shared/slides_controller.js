import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['slide', 'dot', 'prevButton', 'nextButton', 'counter'];

  static values = {
    currentSlide: { type: Number, default: 0 },
    totalSlides: { type: Number, default: 0 },
    autoplay: { type: Boolean, default: false },
    autoplayInterval: { type: Number, default: 5000 }
  }

  connect() {
    this.totalSlidesValue = this.slideTargets.length;
    this.currentSlideValue = 0;
    this.showSlide(0);
    this.setupKeyboardNavigation();
    this.setupTouchNavigation();

    if (this.autoplayValue) {
      this.startAutoplay();
    }
  }

  disconnect() {
    if (this.autoplayTimer) {
      clearInterval(this.autoplayTimer);
    }
  }

  setupKeyboardNavigation() {
    this.boundKeyHandler = this.handleKeyPress.bind(this);
    window.addEventListener('keydown', this.boundKeyHandler);
  }

  setupTouchNavigation() {
    let touchStartX = 0;
    let touchEndX = 0;

    this.element.addEventListener('touchstart', (e) => {
      touchStartX = e.changedTouches[0].screenX;
    }, { passive: true });

    this.element.addEventListener('touchend', (e) => {
      touchEndX = e.changedTouches[0].screenX;
      this.handleSwipe(touchStartX, touchEndX);
    }, { passive: true });
  }

  handleSwipe(startX, endX) {
    const swipeThreshold = 50;
    const diff = startX - endX;

    if (Math.abs(diff) > swipeThreshold) {
      if (diff > 0) {
        this.next();
      } else {
        this.prev();
      }
    }
  }

  handleKeyPress(event) {
    // Ignore if user is typing in input/textarea
    if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') {
      return;
    }

    switch(event.key) {
      case 'ArrowRight':
      case 'ArrowDown':
      case ' ': // Spacebar
        event.preventDefault();
        this.next();
        break;
      case 'ArrowLeft':
      case 'ArrowUp':
        event.preventDefault();
        this.prev();
        break;
      case 'Home':
        event.preventDefault();
        this.goToSlide(0);
        break;
      case 'End':
        event.preventDefault();
        this.goToSlide(this.totalSlidesValue - 1);
        break;
    }
  }

  next() {
    if (this.currentSlideValue < this.totalSlidesValue - 1) {
      this.goToSlide(this.currentSlideValue + 1);
    }
  }

  prev() {
    if (this.currentSlideValue > 0) {
      this.goToSlide(this.currentSlideValue - 1);
    }
  }

  goToSlide(event) {
    let slideIndex;

    if (event && event.type === 'click') {
      // Get index from data attribute
      const indexParam = event.currentTarget?.dataset?.slidesIndexParam;
      slideIndex = indexParam ? parseInt(indexParam, 10) : null;
    } else if (typeof event === 'number') {
      // Direct number passed
      slideIndex = event;
    } else {
      return;
    }

    if (slideIndex === null || slideIndex < 0 || slideIndex >= this.totalSlidesValue) return;

    this.currentSlideValue = slideIndex;
    this.showSlide(slideIndex);

    if (this.autoplayValue) {
      this.resetAutoplay();
    }
  }

  showSlide(index) {
    // Hide all slides first
    this.slideTargets.forEach((slide, i) => {
      if (i === index) {
        // Show target slide
        slide.classList.remove('hidden');
        slide.classList.add('slide-active');
        // Scroll to top of slide
        setTimeout(() => {
          slide.scrollTop = 0;
        }, 100);
      } else {
        // Hide other slides
        slide.classList.add('hidden');
        slide.classList.remove('slide-active');
      }
    });

    // Update dots
    if (this.hasDotTargets) {
      this.dotTargets.forEach((dot, i) => {
        if (i === index) {
          dot.classList.add('active');
          dot.setAttribute('data-active', 'true');
          dot.style.width = '2rem';
          dot.style.backgroundColor = 'white';
          dot.style.opacity = '1';
        } else {
          dot.classList.remove('active');
          dot.removeAttribute('data-active');
          dot.style.width = '0.5rem';
          dot.style.backgroundColor = '';
          dot.style.opacity = '';
        }
      });
    }

    // Update counter
    if (this.hasCounterTargets) {
      this.counterTargets.forEach(counter => {
        counter.textContent = `${index + 1} / ${this.totalSlidesValue}`;
      });
    }

    // Update navigation buttons
    if (this.hasPrevButtonTargets) {
      this.prevButtonTargets.forEach(btn => {
        btn.disabled = index === 0;
        btn.classList.toggle('opacity-50', index === 0);
        btn.classList.toggle('cursor-not-allowed', index === 0);
      });
    }

    if (this.hasNextButtonTargets) {
      this.nextButtonTargets.forEach(btn => {
        btn.disabled = index === this.totalSlidesValue - 1;
        btn.classList.toggle('opacity-50', index === this.totalSlidesValue - 1);
        btn.classList.toggle('cursor-not-allowed', index === this.totalSlidesValue - 1);
      });
    }
  }

  startAutoplay() {
    this.autoplayTimer = setInterval(() => {
      if (this.currentSlideValue < this.totalSlidesValue - 1) {
        this.next();
      } else {
        this.goToSlide(0);
      }
    }, this.autoplayIntervalValue);
  }

  resetAutoplay() {
    if (this.autoplayTimer) {
      clearInterval(this.autoplayTimer);
      this.startAutoplay();
    }
  }
}
