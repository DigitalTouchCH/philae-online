// app/javascript/controllers/fullcalendar_controller.js
import { Controller } from "stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";

export default class extends Controller {
  static targets = ["calendar"];

  connect() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    const calendarEl = this.calendarTarget;

    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
      initialView: "dayGridMonth", // Replace with your desired view
      // Add more configuration options as needed
    });

    calendar.render();
  }
}
