import { Controller } from "stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import bootstrapPlugin from "@fullcalendar/bootstrap";

export default class extends Controller {
  static targets = ["calendar"];

  connect() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    const calendarEl = this.calendarTarget;
    // Utilisez dataset pour accéder aux data-attributes
    const eventsUrl = this.calendarTarget.dataset.eventsUrl;
    console.log("Events URL: ", eventsUrl);

    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, bootstrapPlugin],
      themeSystem: "bootstrap",
      initialView: "dayGridMonth",
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,timeGridDay",
      },
      events: eventsUrl,
      eventBackgroundColor: "#007BFF",
      eventBorderColor: "#007BFF",
      eventTextColor: "#FFFFFF",
    });

    calendar.render();
  }
}
