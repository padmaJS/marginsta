import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["summarizeButton", "content", "spinner"]

  connect() {
    document.addEventListener('summary:loaded', this.hideLoading.bind(this))
  }

  showLoading() {
    this.summarizeButtonTarget.disabled = true
    this.contentTarget.classList.add('d-none')
    this.spinnerTarget.classList.remove('d-none')
  }

  hideLoading() {
    this.summarizeButtonTarget.disabled = false
    this.contentTarget.classList.remove('d-none')
    this.spinnerTarget.classList.add('d-none')
  }
}