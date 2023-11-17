import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "textArea", "editButton", "saveButton", "therapistSelect"]

  edit(event) {
    event.preventDefault();
    let card = event.currentTarget.closest('.card[data-controller="edit-firm"]');
    let firmId = card.dataset.firmId;
    this.toggleEditState(false, card);

    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    let therapistSelect = card.querySelector(`[data-edit-firm-target="therapistSelect"]`);

    saveButton.classList.remove('d-none');
    editButton.classList.add('d-none');
    therapistSelect.classList.remove('d-none');
  }

  save(event) {
    let card = event.currentTarget.closest('.card[data-controller="edit-firm"]');
    let firmId = card.dataset.firmId;
    this.toggleEditState(true, card);

    let saveButton = card.querySelector('.saveButton');
    let editButton = card.querySelector('.editButton');
    let therapistSelect = card.querySelector(`[data-edit-firm-target="therapistSelect"]`);

    saveButton.classList.add('d-none');
    editButton.classList.remove('d-none');
    therapistSelect.classList.add('d-none');
  }

  toggleEditState(readonly, card) {
    let inputs = card.querySelectorAll('input');
    let textAreas = card.querySelectorAll('textarea');
    inputs.forEach(input => input.readOnly = readonly);
    textAreas.forEach(textArea => textArea.readOnly = readonly);
  }
}
