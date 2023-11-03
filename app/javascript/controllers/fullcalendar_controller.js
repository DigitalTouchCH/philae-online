import { Controller } from "stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import bootstrapPlugin from "@fullcalendar/bootstrap";
import interactionPlugin from "@fullcalendar/interaction";

// Classe principale du contrôleur qui hérite de Stimulus.Controller
export default class extends Controller {

  // Déclaration des éléments cibles que le contrôleur utilisera
  static targets = ["calendar", "tooltip"];

  // Méthode appelée automatiquement quand le contrôleur est connecté
  connect() {
    console.log(this.hasTooltipTarget);
    this.initializeCalendar();
  }

  // Méthode pour initialiser le calendrier
  initializeCalendar() {


    // Sélection des éléments DOM et récupération des URLs des événements depuis les attributs de données
    const calendarEl = this.calendarTarget;
    const eventsUrl = this.calendarTarget.dataset.eventsUrl;


    // Création d'une nouvelle instance du calendrier avec sa configuration
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, bootstrapPlugin, interactionPlugin],
      themeSystem: "bootstrap5",
      initialView: "timeGridWeek",
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,timeGridDay"
      },
      eventStartEditable: true,
      events: eventsUrl,
      slotDuration: '00:15:00',
      slotMinTime: '06:00:00',
      slotMaxTime: '21:00:00',
      nowIndicator: true,
      navLinks: true,
      navLinkDayClick: 'timeGridWeek',

      eventContent: function(arg) {
        // Créer un élément de contenu d'événement
        let domContent = document.createElement('div');
        domContent.classList.add('event-content');

        // Vérifier la vue actuelle du calendrier et ajuster le contenu en conséquence
        let view = arg.view.type; // Obtenir le type de vue actuel

        switch (view) {
          case 'dayGridMonth': // Vue mensuelle
            // Ajoutez le contenu spécifique à la vue mensuelle
            domContent.innerHTML = `<span class="event-title">${arg.event.title}</span>`;
            break;
          case 'timeGridWeek': // Vue hebdomadaire
          case 'timeGridDay': // Vue journalière
            // Ajoutez le contenu pour les vues hebdomadaire et journalière
            switch (arg.event.extendedProps.eventType) {
              case 'personal':
                domContent.innerHTML = `<span class="event-title">${arg.event.title}</span>
                                        <span class="event-reason">${arg.event.extendedProps.reason}</span>`;
                break;
              case 'group':
                domContent.innerHTML = `<span class="event-title">${arg.event.title}</span>`;
                break;
              case 'individual':
                domContent.innerHTML = `<span class="event-title">${arg.event.title}</span>
                                        <span class="event-patient">Patient: ${arg.event.extendedProps.patient}</span>`;
                break;
              default:
                domContent.innerHTML = `<span class="event-title">${arg.event.title}</span>`;
                break;
            }
            break;
          // Vous pouvez ajouter d'autres cas si vous utilisez d'autres types de vues
        }

        return { domNodes: [domContent] };
      },


      eventDidMount: (info) => {
        info.el.addEventListener('mouseenter', (jsEvent) => {
          this.showTooltip(info.event, jsEvent);
        });
        info.el.addEventListener('mouseleave', () => {
          this.hideTooltip();
        });
      },
    });

    // Gestion des événements de type 'eventDrop' (quand un événement est déplacé)
    calendar.on('eventDrop', info => {

      // Récupération de l'ID du thérapeute
      const therapistId = this.getTherapistIdFromUrl();

      // Récupération du jeton CSRF pour sécuriser la requête AJAX
      const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

      // Construction de l'objet de données de l'événement déplacé
      const eventData = {
        event_id: info.event.id,
        event_type: info.event.extendedProps.eventType,
        start: info.event.start.toISOString(),
        end: info.event.end ? info.event.end.toISOString() : null
      };

      // Envoi de la requête PATCH au serveur pour mettre à jour l'événement
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

    // Affichage du calendrier
    calendar.render();
  }

  // Méthode pour afficher l'infobulle
  showTooltip(event, jsEvent) {
    const tooltipElement = this.tooltipTarget;

    // Contenu par défaut de l'infobulle
    let tooltipContent = `Event: ${event.title}`;

    // Personnalisez le contenu de l'infobulle selon le type d'événement
    switch (event.extendedProps.eventType) {
      case 'personal':
        tooltipContent += `<br>Reason: ${event.extendedProps.reason}`;
        break;
      case 'group':
        // Ajoutez des détails spécifiques aux événements de groupe si nécessaire
        //tooltipContent += `<br>Location: ${event.extendedProps.location}`;
        break;
      case 'individual':
        tooltipContent += `<br>Patient: ${event.extendedProps.patient}`;
        break;
      // Vous pouvez ajouter plus de cas pour d'autres types d'événements
      default:
        // Informations par défaut pour les événements non spécifiés
        tooltipContent += `<br>Details: Standard event`;
        break;
    }

    tooltipElement.innerHTML = tooltipContent;
    tooltipElement.style.display = 'block';
    tooltipElement.style.left = `${jsEvent.pageX}px`;
    tooltipElement.style.top = `${jsEvent.pageY}px`;
  }

  // Méthode pour cacher l'infobulle
  hideTooltip() {
    const tooltipElement = this.tooltipTarget;
    tooltipElement.style.display = 'none';
  }

  // Méthode pour extraire l'ID du thérapeute depuis l'URL
  getTherapistIdFromUrl() {
  const pathSegments = window.location.pathname.split('/'); // diviser l'URL en segments
  const therapistIdIndex = pathSegments.indexOf('therapists') + 1; // trouver l'index de 'therapists' et obtenir l'index de l'ID
  return pathSegments[therapistIdIndex]; // retourner l'ID du thérapeute
}
}
