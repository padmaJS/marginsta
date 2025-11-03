import { Controller } from "@hotwired/stimulus"
// import consumer from "../channels/consumer"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["input"]
  static values = { chatId: Number, currentUserId: Number }

  
  connect() {
    this.subscribeToChat()
    this.scrollToBottom()
    this.styleMessages()
    this.initializeMessageObserver()
  }
  
  subscribeToChat() {
    const chatId = this.chatIdValue
    if (!chatId) return

    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatChannel", id: chatId },
      {
        received: (data) => this.handleReceivedData(data)
      }
    )

  }

  handleReceivedData(data) {
    switch(data.action) {
      case 'typing':
        this.handleTypingIndicator(data)
        break
      case 'user_online':
        this.handleOnlineStatus(data)
        break
    }
  }
  
  handleTypingIndicator(data) {
    const indicator = document.getElementById(`typing-indicator-${data.user_id}`)
    if (indicator) {
      indicator.style.display = data.typing ? 'inline' : 'none'
    }
  }
  
  handleOnlineStatus(data) {
    const status = document.getElementById(`online-status-${data.user_id}`)
    if (status) {
      const dot = data.online ? '🟢' : '⚪️'
      status.innerHTML = `<span class='align-middle' style='font-size:1.1em;'>${dot}</span> <span class='align-middle small'>${data.online ? 'online' : 'offline'}</span>`
      status.className = `online-status ${data.online ? 'text-success' : 'text-muted'}`
    }
  }
  
  handleTyping(event) {
    if (!this.channel) return
    
    const action = event.type === 'keydown' && event.key !== 'Enter' ? 'typing_start' : 'typing_stop'
    
    // Debounce typing events
    clearTimeout(this.typingTimeout)
    
    if (action === 'typing_start') {
      this.channel.send({ action: 'typing_start' })
    }
    
    this.typingTimeout = setTimeout(() => {
      this.channel.send({ action: 'typing_stop' })
    }, 1000)
  }
  
  resetForm() {
    this.inputTarget.value = ""
  }
  
  scrollToBottom() {
    const messagesContainer = document.querySelector('.messages-container')
    if (messagesContainer) {
      setTimeout(() => {
        messagesContainer.scrollTop = messagesContainer.scrollHeight
      }, 10)
    }
  }

  styleMessages() {
    const messages = document.querySelectorAll('.message')
    messages.forEach(message => this.styleMessage(message))
  }

  styleMessage(messageElement) {
    const messageUserId = parseInt(messageElement.dataset.messageUserId)
    const currentUserId = this.currentUserIdValue

    if (messageUserId === currentUserId) {
      messageElement.classList.add('bg-primary', 'text-white', 'align-self-end', 'rounded-pill', 'px-3', 'py-2', 'mb-2', 'ms-5', 'shadow-sm')
    } else {
      messageElement.classList.add('bg-light', 'text-dark', 'align-self-start', 'rounded-pill', 'px-3', 'py-2', 'mb-2', 'me-5', 'shadow-sm')
    }
  }

  initializeMessageObserver() {
    const messagesContainer = document.querySelector('.messages-container')
    if (messagesContainer) {
      this.observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          mutation.addedNodes.forEach((node) => {
            if (node.nodeType === 1 && node.classList.contains('message')) {
              this.styleMessage(node)
              this.scrollToBottom()
            }
          })
        })
      })
      
      this.observer.observe(messagesContainer, {
        childList: true,
        subtree: true
      })
    }
  }
}