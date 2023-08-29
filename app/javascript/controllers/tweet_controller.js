import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tweet"
export default class extends Controller {
  static targets = [ 'image', 'outputImageName', 'content', 'outputCount' ]

  static values = {
    characterCount: Number
  }
  connect() {
    this.change()
  }

  change() {
    let length = this.contentTarget.value.length
    this.outputCountTarget.textContent = `${length}/${this.characterCountValue}`
  }

  image() {
    let image_name = this.imageTarget.value
    if (image_name == "") {
      this.outputImageNameTarget.textContent = ''
    } else {
      let replace_image_name = image_name.replace(/C:\\fakepath\\/g, "")
      this.outputImageNameTarget.textContent = `${replace_image_name}`
    }
  }
}
