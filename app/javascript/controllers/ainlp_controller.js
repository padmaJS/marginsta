import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "messageBox", "loading", "form"]

  connect() {
    console.log("AI NLP Controller connected")
    this.scrollToBottom()
  }

  showLoading() {
    this.loadingTarget.classList.remove('d-none')
  }

  hideLoading() {
    this.loadingTarget.classList.add('d-none')
    this.scrollToBottom()
  }

  resetForm() {
    this.inputTarget.value = ''
    this.inputTarget.focus()
  }

  scrollToBottom() {
    setTimeout(() => {
        this.messageBoxTarget.scrollTop = this.messageBoxTarget.scrollHeight
        }, 100);
    }

  // Auto-scroll when new messages are added via Turbo Stream
  messageBoxTargetConnected() {
    this.scrollToBottom()
  }
}
