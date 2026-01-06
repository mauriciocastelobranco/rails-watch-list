import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["short", "full"]

  toggle() {
    this.shortTarget.classList.toggle("d-none")
    this.fullTarget.classList.toggle("d-none")
  }
}
