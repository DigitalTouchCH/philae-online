import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "saveButton", "editButton"]

  connect() {
    console.log("edit firm controller connected!")
    this.inputs = this.element.querySelectorAll('input');
    this.textAreas = this.element.querySelectorAll('textarea');
  }

  edit() {
    this.inputs.forEach(input => input.removeAttribute('readonly'));
    this.textAreas.forEach(textArea => textArea.removeAttribute('readonly'));
    this.editButtonTargets.forEach(button => button.style.display = 'none');
    this.saveButtonTargets.forEach(button => button.style.display = 'block');
  }

  save() {
    this.inputs.forEach(input => input.setAttribute('readonly', true));
    this.textAreas.forEach(textArea => textArea.setAttribute('readonly', true));
    this.editButtonTargets.forEach(button => button.style.display = 'block');
    this.saveButtonTargets.forEach(button => button.style.display = 'none');
    // Add logic to submit the form here if needed
  }

  // The rest of your Stimulus controller...
}
