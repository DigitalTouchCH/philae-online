// slots_calendar_controller.js
import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import timeGridPlugin from "@fullcalendar/timegrid";

export default class extends Controller {
  static values = {
    therapistId: Number,
    serviceId: Number
  };

  connect() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    var calendarEl = this.element;
    this.calendar = new Calendar(calendarEl, {
      plugins: [timeGridPlugin],
      // ...autres options
      events: (fetchInfo, successCallback, failureCallback) => {
        this.loadTimeSlots(fetchInfo, successCallback, failureCallback);
      }
      // ...autres options
    });

    this.calendar.render();
  }

  loadTimeSlots(fetchInfo, successCallback, failureCallback) {
    // Utilisez `therapistIdValue` et `serviceIdValue` pour charger les créneaux
    if (this.therapistIdValue && this.serviceIdValue) {
      const url = `/therapists/${this.therapistIdValue}/services/${this.serviceIdValue}/time_slots.json`;

      fetch(url)
        .then(response => response.json())
        .then(data => {
          // Convertissez les données en format événement FullCalendar si nécessaire
          const events = data.map(slot => ({
            title: 'Créneau disponible',
            start: slot.start_time,
            end: slot.end_time
          }));
          successCallback(events);
        })
        .catch(error => {
          failureCallback(error);
        });
    }
  }

  // ...autres méthodes

  updateTherapistId({ detail: { therapistId } }) {
    this.therapistIdValue = therapistId;
    this.calendar.refetchEvents();
  }

  updateServiceId({ detail: { serviceId } }) {
    this.serviceIdValue = serviceId;
    this.calendar.refetchEvents();
  }
}
