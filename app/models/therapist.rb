class Therapist < ApplicationRecord
  belongs_to :firm

  has_many :event_groupes
  has_many :event_individuels
  has_many :event_personels
  has_many :therapist_services
  has_many :services, through: :therapist_services
  has_many :videos
  has_many :week_availabilities
  has_many :users

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :is_manager, inclusion: { in: [true, false] }
  validates :is_active, inclusion: { in: [true, false] }


  def display_name
    "#{first_name} #{last_name}"
  end

  def available_time_slots(service_id, duration, all_week_availabilities)
    end_date = 1.month.from_now
    (Date.tomorrow..end_date).each_with_object([]) do |date, available_slots|
      day_availability = week_availability_for_date(date, all_week_availabilities)

      # Modifier les TimeBlock pour utiliser la date actuelle
      modified_day_availability = day_availability.map do |block|
        start_time = DateTime.parse("#{date} #{block.start_time.strftime('%H:%M:%S')}")
        end_time = DateTime.parse("#{date} #{block.end_time.strftime('%H:%M:%S')}")
        block.dup.tap do |modified_block|
          modified_block.start_time = start_time
          modified_block.end_time = end_time
        end
      end

      booked_slots = booked_slots_for_date(date)
      free_slots = calculate_free_slots(modified_day_availability, booked_slots, duration)
      service_slots = split_slot_by_duration(free_slots, duration)
      available_slots.concat(service_slots.map { |slot| slot.merge(date: date) })
    end
  end

  private

  def week_availability_for_date(date, all_week_availabilities)
    # Créez un mapping entre les jours en anglais et en français
    day_mapping = {
      'monday' => 'Lundi',
      'tuesday' => 'Mardi',
      'wednesday' => 'Mercredi',
      'thursday' => 'Jeudi',
      'friday' => 'Vendredi',
      'saturday' => 'Samedi',
      'sunday' => 'Dimanche'
    }

    # Obtenez le jour de la semaine en anglais et convertissez-le en français
    week_day = day_mapping[date.strftime("%A").downcase]

    # Sélectionnez les TimeBlock pour le jour donné
    all_week_availabilities
      .select { |wa| wa.valid_from <= date && wa.valid_until >= date }
      .flat_map { |wa| wa.time_blocks }
      .select { |tb| tb.week_day == week_day }
  end

  def calculate_free_slots(day_availability, booked_slots, service_duration)
    free_slots = []
    last_slot_end_time = nil

    day_availability.each do |available_block|
      time = available_block.start_time
      end_time = available_block.end_time

      while time + service_duration.minutes <= end_time
        # Vérifier si le créneau actuel chevauche un créneau occupé ou le dernier créneau ajouté
        if booked_slots.none? { |booked| overlap?(time, time + service_duration.minutes, booked[:start_time], booked[:end_time]) } &&
           (last_slot_end_time.nil? || time >= last_slot_end_time)

          # Ajouter le créneau à la liste des créneaux libres
          free_slots << { start_time: time, end_time: time + service_duration.minutes }
          last_slot_end_time = time + service_duration.minutes
        end

        # Passer au prochain créneau de 15 minutes
        time += 10.minutes
      end
    end

    free_slots
  end


  def booked_slots_for_date(date)
    events = event_individuels.where('start_date_time >= ? AND start_date_time <= ?', date.beginning_of_day, date.end_of_day)
    events += event_groupes.where('start_date_time >= ? AND start_date_time <= ?', date.beginning_of_day, date.end_of_day)
    events += event_personels.where('start_date_time >= ? AND start_date_time <= ?', date.beginning_of_day, date.end_of_day)

    events.map { |e| { start_time: e.start_date_time, end_time: e.end_date_time } }
  end

  def split_slot_by_duration(slots, duration)
    # Cette méthode divise un créneau horaire en plusieurs sous-crénneaux basés sur la durée donnée.
    # slot: { start_time: DateTime, end_time: DateTime }
    # duration: durée en minutes
    split_slots = []
    slots.each do |slot|
      start_time = slot[:start_time]
      while start_time + duration.minutes <= slot[:end_time]
        end_time = start_time + duration.minutes
        split_slots << { start_time: start_time, end_time: end_time }
        start_time += duration.minutes
      end
    end
    split_slots
  end


  def overlap?(start1, end1, start2, end2)
    start1 < end2 && start2 < end1
  end

end
