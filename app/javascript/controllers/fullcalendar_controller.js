import { Controller } from "stimulus";
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

export default class extends Controller {
  static targets = ["calendar"];

  connect() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    const calendarEl = this.calendarTarget;

    this.calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin],
      initialView: 'dayGridMonth',
      events: '/events.json'
      // Ajoutez ici d'autres options si nécessaire
    });

    this.calendar.render();
  }
}
