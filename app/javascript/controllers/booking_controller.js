// app/javascript/controllers/booking_controller.js

import { Controller } from "@hotwired/stimulus";

// Contrôleur Stimulus pour la gestion des réservations
export default class extends Controller {
  static targets = ["therapist", "service", "timeSlot"];

  // Connectez le contrôleur lors du chargement de la page
  connect() {
    console.log("BookingController connected"); // Affiche un message dans la console
  }

  loadServices() {
    // Get the selected therapist ID from the target
    const therapistId = this.therapistTarget.value;
    console.log(`Loading services for therapist: ${therapistId}`);

    if (!therapistId || therapistId === "") {
      this.clearServiceOptions();
      this.clearTimeSlots();
      return; // Exit the function if no therapist is selected
    }

    // Make the AJAX request to the updated Rails route
    fetch(`/services.json?therapist_id=${therapistId}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        // Assume data is an array of services
        this.populateServiceOptions(data);
      })
      .catch(error => {
        console.error("Error fetching services:", error);
        // Handle errors, such as displaying a message to the user
      });
  }

  // Helper function to populate service options
  populateServiceOptions(services) {
    this.serviceTarget.innerHTML = ''; // Clear existing options

    // Add a neutral first option
    const defaultOption = document.createElement('option');
    defaultOption.textContent = "Choisissez un service";
    defaultOption.value = "";
    this.serviceTarget.appendChild(defaultOption);

    // Populate service options
    services.forEach(service => {
        const option = document.createElement('option');
        option.value = service.id;
        option.textContent = service.name;
        this.serviceTarget.appendChild(option);
    });

    // Enable/disable select based on services length
    this.serviceTarget.disabled = services.length === 0;

    // If there's only one service, trigger change event
    if (services.length === 1) {
        this.serviceTarget.value = services[0].id; // Set value to the only service
        this.serviceTarget.dispatchEvent(new Event('change'));
    }
  }





  // Charge les créneaux horaires disponibles pour un service
  loadTimeSlots() {
    const therapistId = this.therapistTarget.value;
    const serviceId = this.serviceTarget.value;

    // Nettoyer la liste des créneaux horaires si aucun service n'est sélectionné
    if (!serviceId || serviceId === "") {
      this.clearTimeSlots();
      return; // Sortir de la fonction si aucun service n'est sélectionné
    }

    console.log(`Loading time slots for therapist: ${therapistId} and service: ${serviceId}`);


    fetch(`/therapists/${therapistId}/services/${serviceId}/time_slots.json`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        this.populateTimeSlots(data);
      })
      .catch(error => {
        console.error("Error fetching time slots:", error);
        // Handle errors, such as displaying a message to the user
      });
  }

  populateTimeSlots(timeSlots) {
    const slotsList = this.timeSlotTarget;
    slotsList.innerHTML = ''; // Vider la liste avant de la remplir

    timeSlots.forEach(slot => {
      const listItem = document.createElement('li');
      listItem.textContent = `Créneau disponible: ${slot.start_time} - ${slot.end_time}`;
      slotsList.appendChild(listItem);
    });
  }

  clearServiceOptions() {
    this.serviceTarget.innerHTML = ''; // Clear service options
  }

  clearTimeSlots() {
    this.timeSlotTarget.innerHTML = ''; // Clear time slots
  }
}
