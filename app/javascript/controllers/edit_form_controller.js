// app/javascript/controllers/edit_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "checkbox", "editButton", "saveButton", "form", "select", "textArea"]

  // METHODES PUBLIQUES

  edit(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-form"]');
    // Activer les champs
    this.toggleEditState(false, card);
    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    // basculer les boutons
    saveButton.classList.remove('d-none');
    editButton.classList.add('d-none');
  }

  save(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-form"]');
    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    // Desactive les champs
    this.toggleEditState(false, card);
    // Soumettre le formulaire
    card.querySelector('form').submit();
    // basculer les boutons
    this.toggleEditState(true, card);
    saveButton.classList.add('d-none');
    editButton.classList.remove('d-none');
  }

  toggleCheckbox(event) {
    let checkbox = event.target;
    let hiddenField = checkbox.closest('form').querySelector('input[type=hidden][name="' + checkbox.name + '"]');
    if (hiddenField) {
      hiddenField.disabled = checkbox.checked;
    }
  }

  // METHODES PRIVEES

  toggleEditState(readonly, card) {
    let inputs = card.querySelectorAll('input');
    let selects = card.querySelectorAll('select');
    let checkboxes = card.querySelectorAll('input[type="checkbox"]');
    let textAreas = card.querySelectorAll('textarea');
    inputs.forEach(input => input.readOnly = readonly);
    selects.forEach(select => select.disabled = readonly);
    textAreas.forEach(textArea => textArea.readOnly = readonly);
    checkboxes.forEach(checkbox => checkbox.disabled = readonly);
  }
}
