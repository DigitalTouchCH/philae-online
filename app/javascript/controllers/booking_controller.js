// app/javascript/controllers/booking_controller.js

import { Controller } from "@hotwired/stimulus";

// Contrôleur Stimulus pour la gestion des réservations
export default class extends Controller {
  static targets = ["therapist", "service", "timeSlot", "calendar"];
  previousTherapistId = '';
  previousServiceId = '';

  // Fonction appelée automatiquement lorsque le contrôleur est connecté à l'élément du DOM
  connect() {
    console.log("BookingController connected");
    this.setupEventListeners();
    // Stocker les valeurs initiales
    // this.previousTherapistId = this.therapistTarget.value;
    // this.previousServiceId = this.serviceTarget.value;
  }

  // Configuration des écouteurs d'événements pour réagir aux sélections de thérapeutes et de services
  setupEventListeners() {
    window.addEventListener('therapist-selected', (event) => {
      this.serviceTarget.selectedIndex = 0; // Réinitialiser la sélection du service
      this.clearTimeSlots();
      this.hideCalendar();
    });

    window.addEventListener('service-selected', (event) => {
      this.loadTimeSlots(event.detail.serviceId);
    });

    // this.therapistTarget.addEventListener('change', () => {
    //   const currentTherapistId = this.therapistTarget.value;
    //   if (this.previousTherapistId !== currentTherapistId) {
    //     this.previousTherapistId = currentTherapistId;
    //     this.refreshPageWithParams({ therapist_id: currentTherapistId });
    //   }
    // });

    // this.serviceTarget.addEventListener('change', () => {
    //   const currentServiceId = this.serviceTarget.value;
    //   if (this.previousServiceId !== currentServiceId) {
    //     this.previousServiceId = currentServiceId;
    //     const therapistId = this.therapistTarget.value;
    //     this.refreshPageWithParams({ therapist_id: therapistId, service_id: currentServiceId });
    //   }
    // });
  }

  // refreshPageWithParams(params) {
  //   const queryString = new URLSearchParams(params).toString();
  //   window.location.href = `${window.location.pathname}?${queryString}`;
  // }

  // Fonction pour charger les services d'un thérapeute sélectionné
  loadServices() {
    const therapistId = this.therapistTarget.value;
    console.log(`Chargement des services pour le thérapeute : ${therapistId}`);

    if (!therapistId || therapistId === "") {
      this.clearServiceOptions();
      this.clearTimeSlots();
      this.hideCalendar();
      return; // Sortir de la fonction si aucun thérapeute n'est sélectionné
    }

    // Déclenchez un événement lorsque l'utilisateur sélectionne un thérapeute
    const event = new CustomEvent('therapist-selected', { detail: { therapistId: this.therapistTarget.value } });
    window.dispatchEvent(event);

    // Faire une requête AJAX pour récupérer les services
    fetch(`/services.json?therapist_id=${therapistId}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        this.populateServiceOptions(data);
      })
      .catch(error => {
        console.error("Erreur de chargement des services :", error);
      });
  }

  // Fonction pour charger les créneaux horaires disponibles d'un service
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
        const event = new CustomEvent('service-changed', { detail: { timeSlots: data } });
        window.dispatchEvent(event); // Déclenchez l'événement pour mettre à jour le calendrier
      })
      .catch(error => {
        console.error("Error fetching time slots:", error);
      });
  }

  // Fonction pour peupler les options de service dans le menu déroulant
  populateServiceOptions(services) {
    this.serviceTarget.innerHTML = ''; // Effacer les options existantes

    // Ajouter une première option neutre
    const defaultOption = document.createElement('option');
    defaultOption.textContent = "Choisissez un service";
    defaultOption.value = "";
    this.serviceTarget.appendChild(defaultOption);

    // Remplir les options de service
    services.forEach(service => {
        const option = document.createElement('option');
        option.value = service.id;
        option.textContent = service.name;
        this.serviceTarget.appendChild(option);
    });

    // Activer/désactiver le menu déroulant en fonction du nombre de services
    this.serviceTarget.disabled = services.length === 0;

    // Si un seul service est présent, déclencher l'événement de changement
    if (services.length === 1) {
        this.serviceTarget.value = services[0].id;
        this.serviceTarget.dispatchEvent(new Event('change'));
    }

    // Si un seul service est présent, déclenchez l'événement pour le chargement des créneaux horaires
    if (services.length === 1) {
      const event = new CustomEvent('service-selected', { detail: { serviceId: services[0].id } });
      window.dispatchEvent(event);
    }

    // Mettez à jour les attributs de données pour FullCalendar en fonction du thérapeute sélectionné
    const slotsCalendarElement = document.querySelector('[data-controller="slots-calendar"]');
    if (slotsCalendarElement) {
      slotsCalendarElement.dataset.slotsCalendarTherapistIdValue = this.therapistTarget.value;
    }
  }

  // Fonction pour peupler la liste des créneaux horaires disponibles
  populateTimeSlots(timeSlots) {
    const slotsList = this.timeSlotTarget;
    slotsList.innerHTML = ''; // Vider la liste avant de la remplir

    timeSlots.forEach(slot => {
      const listItem = document.createElement('li');
      listItem.textContent = `Créneau disponible: ${slot.start_time} - ${slot.end_time}`;
      slotsList.appendChild(listItem);
    });

    // Mettez à jour les attributs de données pour FullCalendar en fonction du service sélectionné
    const slotsCalendarElement = document.querySelector('[data-controller="slots-calendar"]');
    if (slotsCalendarElement) {
      slotsCalendarElement.dataset.slotsCalendarServiceIdValue = this.serviceTarget.value;
    }

    this.showCalendar(); // Montrez le calendrier lorsque les créneaux sont disponibles
  }

  // Fonction pour vider les options de service
  clearServiceOptions() {
    this.serviceTarget.innerHTML = ''; // Clear service options
  }

  // Fonction pour vider la liste des créneaux horaires
  clearTimeSlots() {
    this.timeSlotTarget.innerHTML = '';
  }

  // Fonction pour cacher le calendrier
  hideCalendar() {
    this.calendarTarget.style.display = 'none'; // Cacher le calendrier
  }

  showCalendar() {
    this.calendarTarget.style.display = 'block'; // Afficher le calendrier
  }


}
