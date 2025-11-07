import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "loading", "results"]
    static values = { url: String }


    connect() {
        this.debouncedSearch = this.debounce(this._search.bind(this), 300)

        this.modalElement = this.element.querySelector('.modal')
        const input = document.querySelector('[data-search-modal-target="input"]');
        
        if (input) input.focus();

        if (this.modalElement) {
            this.modalElement.addEventListener('modal:close', () => {
            this.clearResults()
            })
        }
    }

    debounce(func, delay) {
        let timeoutId
        return (...args) => {
        clearTimeout(timeoutId)
        timeoutId = setTimeout(() => func(...args), delay)
        }
    }


    _search() {
        const query = this.inputTarget.value.trim()
        
        if (query.length === 0) {
        this.clearResults()
        return
        }

        const url = new URL(this.urlValue, window.location.origin)
        url.searchParams.set('query', query)

        fetch(url, {
        headers: {
            'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
        }
        })
        .then(response => {
            if (response.ok) {
                return response.text()
            }
            throw new Error('Network response was not ok.')
        })
        .then(html => {
            Turbo.renderStreamMessage(html)
        })
        .catch(error => {
            console.error('Search failed:', error)
            this.resultsTarget.innerHTML = '<p class="text-danger">Search failed. Please try again.</p>'
        })
        .finally(() => {
            this.hideLoading()
        })
    }


    search(event) {
        this.showLoading()
        this.debouncedSearch()
    }

    clearResults() {
        this.inputTarget.value = ''
    }

    showLoading() {
        this.loadingTarget.classList.remove('d-none')
    }

    hideLoading() {
        this.loadingTarget.classList.add('d-none')
    }

}