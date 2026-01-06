import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  // Define que aceitamos uma URL via valores
  static values = { url: String }

  connect() {
    // 1. Definimos as configurações BASE primeiro (para a variável 'settings' sempre existir)
    let settings = {
      create: false,         // Não permite criar filmes novos que não existem
      valueField: 'value',
      labelField: 'text',
      searchField: 'text'
    }

    // 2. Se tivermos uma URL (o caso do AJAX), adicionamos as configurações de busca remota
    if (this.hasUrlValue) {
      settings.load = (query, callback) => {
        // Se digitou menos de 2 letras, não busca
        if (query.length < 2) return callback()

        const url = `${this.urlValue}?q=${encodeURIComponent(query)}`

        fetch(url)
          .then(response => response.json())
          .then(json => {
            callback(json)
          })
          .catch(() => {
            callback()
          })
      }

      // Configuração visual para mostrar a imagem (apenas se tiver URL)
      settings.render = {
        option: function(data, escape) {
          const imageHtml = data.image ? `<img src="${data.image}" class="me-2" style="height: 50px; width: 35px; object-fit: cover;">` : ''
          return `
            <div class="d-flex align-items-center">
              ${imageHtml}
              <span>${escape(data.text)}</span>
            </div>
          `
        },
        item: function(data, escape) {
          return `<div>${escape(data.text)}</div>`
        }
      }
    }

    // 3. Inicializa o Tom Select com a variável 'settings' que criamos acima
    this.tom = new TomSelect(this.element, settings)
  }

  disconnect() {
    if (this.tom) this.tom.destroy()
  }
}
