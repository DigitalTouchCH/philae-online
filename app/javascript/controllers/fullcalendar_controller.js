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
      themeSystem: "bootstrap5",
      initialView: "dayGridMonth",

      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek"
      },

      events: eventsUrl,

      slotDuration: '00:15:00',
      slotMinTime: '06:00:00',
      slotMaxTime: '20:00:00',
      nowIndicator: true,
      navLinks: true,
      navLinkDayClick: 'timeGridWeek'

      // eventDidMount: function(info) {
      //   new Tooltip(info.el, {
      //     title: info.event.extendedProps.reason, // Accédez à la propriété 'reason' ici
      //     placement: 'top',
      //     trigger: 'hover',
      //     container: 'body'
      //   });
      // }

    });

    calendar.render();
  }
}
