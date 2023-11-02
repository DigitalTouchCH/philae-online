import { Controller } from "stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import bootstrapPlugin from "@fullcalendar/bootstrap";
import interactionPlugin from "@fullcalendar/interaction";

export default class extends Controller {
  static targets = ["calendar", "tooltip"];

  connect() {
    console.log(this.hasTooltipTarget);
    this.initializeCalendar();
  }

  initializeCalendar() {
    const calendarEl = this.calendarTarget;
    const eventsUrl = this.calendarTarget.dataset.eventsUrl;
    console.log("Events URL: ", eventsUrl);



    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, bootstrapPlugin, interactionPlugin],
      themeSystem: "bootstrap5",
      initialView: "dayGridMonth",
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,timeGridDay"
      },
      eventStartEditable: true,
      events: eventsUrl,
      slotDuration: '00:15:00',
      slotMinTime: '06:00:00',
      slotMaxTime: '20:00:00',
      nowIndicator: true,
      navLinks: true,
      navLinkDayClick: 'timeGridWeek',
      eventDidMount: (info) => {
        info.el.addEventListener('mouseenter', (jsEvent) => {
          this.showTooltip(info.event, jsEvent);
        });
        info.el.addEventListener('mouseleave', () => {
          this.hideTooltip();
        });
      },
    });

    // Gestionnaire d'événements pour 'eventDrop'
    calendar.on('eventDrop', info => {
      // Récupérez l'ID du thérapeute à partir d'un data-attribute, par exemple
      const therapistId = calendarEl.dataset.therapistId;
      console.log("Therapist ID: ", therapistId);
      const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

      const eventData = {
        event_id: info.event.id,
        event_type: info.event.extendedProps.eventType,
        start: info.event.start.toISOString(),
        end: info.event.end ? info.event.end.toISOString() : null
      };

      // Envoyez la requête PATCH au serveur
      fetch(`/therapists/${therapistId}/update_event`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(eventData)
      })
      .then(response => response.json())
      .then(data => {
        if (!data.success) {
          console.error('Update failed:', data.errors || data.message);
          // Vous pouvez ajouter une logique pour annuler le déplacement de l'événement ici si nécessaire
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });

    calendar.render();
  }

  showTooltip(event, jsEvent) {
    const tooltipElement = this.tooltipTarget;
    tooltipElement.innerHTML = `Event: ${event.title}<br>Start: ${event.start}<br>Reason: ${event.extendedProps.reason}`;
    tooltipElement.style.display = 'block';

    // Dynamically set the position of the tooltip
    tooltipElement.style.left = jsEvent.pageX + 'px';
    tooltipElement.style.top = jsEvent.pageY + 'px';
  }


  hideTooltip() {
    // Cachez l'infobulle
    const tooltipElement = this.tooltipTarget;
    tooltipElement.style.display = 'none';
  }
}
