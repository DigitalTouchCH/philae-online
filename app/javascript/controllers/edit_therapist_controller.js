// app/javascript/controllers/edit_therapist_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "checkbox", "editButton", "saveButton", "form"]

  edit(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-therapist"]');
    this.toggleEditState(false, card);

    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');

    saveButton.classList.remove('d-none');
    editButton.classList.add('d-none');
  }

  save(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-therapist"]');
    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');

    this.toggleEditState(true, card);

    // Réactivez temporairement la checkbox pour la soumission du formulaire, si nécessaire
    let checkbox = card.querySelector('input[type="checkbox"]');
    if (checkbox) {
      checkbox.disabled = false;
    }

    // Soumettre le formulaire après que les champs ont été désactivés
    card.querySelector('form').submit();

    // Rétablir l'état désactivé pour la checkbox après la soumission du formulaire
    if (checkbox) {
      checkbox.disabled = true;
    }

    saveButton.classList.add('d-none');
    editButton.classList.remove('d-none');
  }


  toggleEditState(readonly, card) {
    let inputs = card.querySelectorAll('input');
    let textAreas = card.querySelectorAll('textarea');
    let checkboxes = card.querySelectorAll('input[type="checkbox"]');
    inputs.forEach(input => input.readOnly = readonly);
    textAreas.forEach(textArea => textArea.readOnly = readonly);
    checkboxes.forEach(checkbox => checkbox.disabled = readonly);
  }

  toggleCheckbox(event) {
    let checkbox = event.target;
    let hiddenField = checkbox.closest('form').querySelector('input[type=hidden][name="' + checkbox.name + '"]');
    if (hiddenField) {
      hiddenField.disabled = checkbox.checked;
    }
  }
}
