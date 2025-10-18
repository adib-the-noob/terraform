class Timer {
  constructor() {
    this.totalTime = 0;
    this.remainingTime = 0;
    this.isRunning = false;
    this.intervalId = null;

    this.minutesDisplay = document.getElementById("minutes");
    this.secondsDisplay = document.getElementById("seconds");
    this.timerInput = document.getElementById("timer-input");
    this.startBtn = document.getElementById("start-btn");
    this.pauseBtn = document.getElementById("pause-btn");
    this.resetBtn = document.getElementById("reset-btn");
    this.progressBar = document.getElementById("progress");

    this.bindEvents();
    this.updateDisplay();
  }

  bindEvents() {
    this.startBtn.addEventListener("click", () => this.start());
    this.pauseBtn.addEventListener("click", () => this.pause());
    this.resetBtn.addEventListener("click", () => this.reset());
    this.timerInput.addEventListener("input", () => this.setTime());
  }

  setTime() {
    const minutes = parseInt(this.timerInput.value) || 5;
    this.totalTime = minutes * 60;
    this.remainingTime = this.totalTime;
    this.updateDisplay();
    this.updateProgress();
  }

  start() {
    if (!this.isRunning) {
      if (this.remainingTime === 0) {
        this.setTime();
      }

      this.isRunning = true;
      this.startBtn.textContent = "Running...";
      this.startBtn.disabled = true;

      this.intervalId = setInterval(() => {
        this.remainingTime--;
        this.updateDisplay();
        this.updateProgress();

        if (this.remainingTime <= 0) {
          this.complete();
        }
      }, 1000);
    }
  }

  pause() {
    if (this.isRunning) {
      this.isRunning = false;
      clearInterval(this.intervalId);
      this.startBtn.textContent = "Resume";
      this.startBtn.disabled = false;
    }
  }

  reset() {
    this.isRunning = false;
    clearInterval(this.intervalId);
    this.setTime();
    this.startBtn.textContent = "Start";
    this.startBtn.disabled = false;
  }

  complete() {
    this.isRunning = false;
    clearInterval(this.intervalId);
    this.startBtn.textContent = "Start";
    this.startBtn.disabled = false;

    // Flash effect
    document.body.classList.add("timer-complete");
    setTimeout(() => {
      document.body.classList.remove("timer-complete");
    }, 2000);

    // Play notification sound (if browser supports it)
    try {
      const audio = new Audio(
        "data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBDuR2u/BdC4GJnLJ+diNOwkWXrjq46hVGghHn97zs2giAzqK1/LHeSUFLH/M8N2QQAoUXrTq36hVFAhHn97yvmwhBDuS2+/BdC4GJnLJ+diNOwkWXrjq46hVGgg=",
      );
      audio.play();
    } catch (e) {
      // Fallback: visual notification only
    }

    alert("Timer completed!");
  }

  updateDisplay() {
    const minutes = Math.floor(this.remainingTime / 60);
    const seconds = this.remainingTime % 60;

    this.minutesDisplay.textContent = minutes.toString().padStart(2, "0");
    this.secondsDisplay.textContent = seconds.toString().padStart(2, "0");
  }

  updateProgress() {
    const progress =
      ((this.totalTime - this.remainingTime) / this.totalTime) * 100;
    this.progressBar.style.width = progress + "%";
  }
}

// Initialize timer when page loads
document.addEventListener("DOMContentLoaded", () => {
  new Timer();
});
