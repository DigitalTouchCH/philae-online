// app/javascript/controllers/edit_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "checkbox", "editButton", "saveButton", "editIcon", "saveIcon", "form", "select", "textArea"]

  // METHODES PUBLIQUES

  edit(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-form"]');
    // Activer les champs
    this.toggleEditState(false, card);
    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    let editIcon = card.querySelector('.editIcon');
    let saveIcon = card.querySelector('.saveIcon');
    // basculer les boutons
    saveButton.classList.remove('d-none');
    editButton.classList.add('d-none');
    editIcon.classList.add('d-none');
    saveIcon.classList.remove('d-none');
  }

  save(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-form"]');
    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    let editIcon = card.querySelector('.editIcon');
    let saveIcon = card.querySelector('.saveIcon');
    // Desactive les champs
    this.toggleEditState(false, card);
    // Soumettre le formulaire
    card.querySelector('form').submit();
    // basculer les boutons
    this.toggleEditState(true, card);
    saveButton.classList.add('d-none');
    editButton.classList.remove('d-none');
    editIcon.classList.remove('d-none');
    saveIcon.classList.add('d-none');
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
    inputs.forEach(input => {
      input.readOnly = readonly;
      readonly ? input.classList.remove('form-editable') : input.classList.add('form-editable');
    });
    selects.forEach(select => {
      select.disabled = readonly;
      readonly ? select.classList.remove('form-editable') : select.classList.add('form-editable');
    });
    textAreas.forEach(textArea => {
      textArea.readOnly = readonly;
      readonly ? textArea.classList.remove('form-editable') : textArea.classList.add('form-editable');
    });
    checkboxes.forEach(checkbox => {
      checkbox.disabled = readonly;
      readonly ? checkbox.classList.remove('form-editable') : checkbox.classList.add('form-editable');
    });
  }

}
