# db/seeds.rb
require 'roo'
require 'faker'

puts "Purging database..."

VideoPatient.destroy_all
EventPersonel.destroy_all
EventIndividuel.destroy_all
EventGroupe.destroy_all
PatientEventGroupe.destroy_all
Ordonnance.destroy_all
TherapistService.destroy_all
Service.destroy_all
Video.destroy_all
WeekAvailability.destroy_all
Room.destroy_all
Location.destroy_all
Therapist.destroy_all
Patient.destroy_all
User.destroy_all
Firm.destroy_all

puts "Database purged."

# ADMIN

puts "Creating admin users..."

user1 = User.create!(
  email: 'thomas.murat974@gmail.com',
  password: 'Lise974*-+',
  password_confirmation: 'Lise974*-+',
  is_admin: true
)
user2 = User.create!(
  email: 'duclos.solen@gmail.com',
  password: 'Lise974*-+',
  password_confirmation: 'Lise974*-+',
  is_admin: true
)

puts "Admin users created."

# FIRMS

puts "Creating firms..."
solen_duclos_ri = Firm.create!(
  name: "Solen Duclos RI",
  address: "Rue Saint-Laurent 19, 1003, Lausanne"
)

anne_laure_croquet_ri = Firm.create!(
  name: "Anne-Laure Croquet RI",
  address: "inconnue"
)
puts "Firms created."

# THERAPEUTES
puts "Creating therapists..."
user3 = User.create!(
  email: 'solen@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123'
)
therapist3 = Therapist.create!(
  user: user3,
  first_name: 'Solen',
  last_name: 'Duclos',
  is_manager: true,
  firm: solen_duclos_ri
)
user4 = User.create!(
  email: 'amelie@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123'
)
therapist4 = Therapist.create!(
  user: user4,
  first_name: 'Amelie',
  last_name: 'Teil',
  is_manager: false,
  firm: solen_duclos_ri
)
user5 = User.create!(
  email: 'alexandre@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123'
)
therapist5 = Therapist.create!(
  user: user5,
  first_name: 'Alexandre',
  last_name: 'Dessert',
  is_manager: false,
  firm: solen_duclos_ri
)

user6 = User.create!(
  email: 'anne-laure@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123'
)
therapist6 = Therapist.create!(
  user: user6,
  first_name: 'Anne-Laure',
  last_name: 'Croquet',
  is_manager: true,
  firm: anne_laure_croquet_ri
)
puts "Therapists created."


# LOCATIONS & ROOMS
puts "Creating locations and room..."
riponne = Location.create!(
  name: "Riponne",
  address: "Rue Saint-Laurent 19, 1003, Lausanne",
  acces_detail: "2e étage sonner à Espace 19"
)

Room.create!(
  name: "Salle 1 à Riponne",
  location: riponne
)

joliette = Location.create!(
  name: "Centre Philae sous-gare",
  address: "Chemin de la joliette 2, 1006, Lausanne",
  acces_detail: "1er étage"
)

5.times do |i|
  Room.create!(
    name: "Salle #{i + 1} à Joliette",
    location: joliette
  )
end

puts "Firme and rooms created."

# EVENTS

puts "Creating personal events for therapists..."

therapists = Therapist.all
start_time = Time.now.beginning_of_day + 11.hours # Start at 11:00 tomorrow
end_time = Time.now.beginning_of_day + 13.hours   # End at 13:00 tomorrow

puts "Start time: #{start_time}"
puts "End time: #{end_time}"

therapists.each do |therapist|
  5.times do |i| # Creating 5 events for each therapist
    EventPersonel.create!(
      therapist: therapist,
      start_date_time: start_time + i.days,
      end_date_time: end_time + i.days,
      reason: "Event #{i+1}",
      is_paid_holiday: false
    )
  end
end

puts "Personal events created."


# PATIENTS
puts "Importing patients..."

# Load Excel file
xlsx = Roo::Spreadsheet.open('./db/data/Listes RDV.xlsx')
# Select the first sheet
sheet = xlsx.sheet(3)

# Itérez sur chaque ligne de la feuille de calcul
full_names = []
sheet.each_row_streaming(offset: 1) do |row|
  full_names << row[0].value
end

filtered_names = full_names.reject { |name| name.start_with?("_") }.map do |full_name|
  # Séparation du nom complet en mots et répartition en nom et prénom
  *last_name_parts, first_name = full_name.split
  last_name = last_name_parts.join(' ')
  [first_name, last_name]
end

patient_comments = [
  "Le patient présente une anxiété marquée dans les situations sociales.",
  "Manifeste un intérêt accru pour les activités artistiques comme moyen d'expression.",
  "Suit un régime alimentaire spécifique dû à des allergies alimentaires multiples.",
  "A des antécédents familiaux de dépression, à surveiller de près pour des signes similaires.",
  "Le patient a montré une amélioration notable suite à l'ajustement de son traitement médicamenteux.",
  "Exprime régulièrement des difficultés à s'endormir et à maintenir un sommeil réparateur.",
  "Rapporte un niveau de douleur chronique qui interfère avec les activités quotidiennes.",
  "Le patient utilise la méditation et le yoga comme stratégies d'atténuation du stress.",
  "A une histoire de traumatisme dans l'enfance qui pourrait être pertinent pour les problèmes actuels.",
  "Le patient a exprimé une motivation croissante pour s'engager dans des thérapies comportementales."
]


filtered_names.each do |first_name, last_name|
  Patient.create!(
    first_name: first_name,
    last_name: last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 80),
    commentaire: patient_comments.sample
  )
end

puts "Patients imported."

# Créer des services avec les attributs nécessaires
puts "Creating services..."
general_physio = Service.create!(
  name: "Physiothérapie générale",
  name_short: "Physio",
  active: true,
  duration_per_unit: 30, # Supposons que la durée par unité est de 30 minutes
  is_group: false, # Supposons que ce service est individuel
  color: "#FF0000" # Couleur rouge
)
female_perineal_reeducation = Service.create!(
  name: "Rééducation périnéale féminine",
  name_short: "R. périnée",
  active: true,
  duration_per_unit: 45, # Supposons que la durée par unité est de 45 minutes
  is_group: false,
  color: "#00FF00" # Couleur verte
)
vestibular_reeducation = Service.create!(
  name: "Rééducation vestibulaire",
  name_short: "R. vestibulaire",
  active: true,
  duration_per_unit: 30, # Supposons que la durée par unité est de 30 minutes
  is_group: false,
  color: "#0000FF" # Couleur bleue
)
puts "Services created."

# Associer des services spécifiques à des thérapeutes par leur nom
puts "Assigning specific services to therapists by name..."

# Solen Duclos - Physiothérapie générale et Rééducation vestibulaire
solen = Therapist.find_by(last_name: 'Duclos')
TherapistService.create!(therapist: solen, service: general_physio)
TherapistService.create!(therapist: solen, service: vestibular_reeducation)

# Amelie Teil - Rééducation périnéale féminine
amelie = Therapist.find_by(last_name: 'Teil')
TherapistService.create!(therapist: amelie, service: female_perineal_reeducation)

# Alexandre Dessert - Physiothérapie générale
alexandre = Therapist.find_by(last_name: 'Dessert')
TherapistService.create!(therapist: alexandre, service: general_physio)

# Anne-Laure Croquet - Tous les services
anne_laure = Therapist.find_by(last_name: 'Croquet')
TherapistService.create!(therapist: anne_laure, service: general_physio)
TherapistService.create!(therapist: anne_laure, service: female_perineal_reeducation)

puts "Specific services assigned to therapists by name."


# db/seeds.rb

# Création de 20 prescripteurs avec des informations aléatoires
20.times do
  Prescripteur.create!(
    name: Faker::Name.name,
    address: Faker::Address.full_address,
    tel: Faker::PhoneNumber.phone_number,
    mail: Faker::Internet.email
  )
end

# Liste de commentaires synthétisant le contenu de l'ordonnance
ordonnance_comments = [
  "Première consultation post-opératoire, rééducation recommandée.",
  "Douleurs lombaires persistantes, nécessite une attention particulière.",
  "Réadaptation à l'effort suite à une longue période d'inactivité.",
  "Renforcement musculaire pour préparation d'une compétition sportive.",
  "Thérapie manuelle requise pour amélioration de la mobilité articulaire.",
  "Programme de rééducation respiratoire suite à une infection pulmonaire.",
  "Gestion de la douleur chronique par des techniques de relaxation.",
  "Amélioration de la posture et de l'équilibre avec exercices spécifiques.",
  "Exercices de réhabilitation pour une récupération post-accident.",
  "Traitement de la fatigue musculaire due à un surmenage professionnel."
]

# Liste de titres courts pour les ordonnances
ordonnance_titles = [
  "Physio genoux",
  "Fuite urinaire",
  "Rééducation épaule",
  "Douleur cervicale",
  "Thérapie de la main",
  "Renforcement abdominal",
  "Migraines fréquentes",
  "Suivi post-natal",
  "Lombalgie chronique",
  "Stress et anxiété"
]

# Assigner 0 à 3 ordonnances pour chaque patient
Patient.find_each do |patient|
  # Générer un nombre aléatoire d'ordonnances, avec un poids pour 0 ordonnance
  num_of_ordonnances = [0, 1, 1, 2, 2, 3].sample
  next if num_of_ordonnances == 0

  num_of_ordonnances.times do
    Ordonnance.create!(
      date_prescription: Faker::Date.between(from: 1.year.ago, to: Date.today),
      num_of_session: rand(1..10), # ou toute autre logique appropriée pour num_of_session
      title: ordonnance_titles.sample,
      commentaire: ordonnance_comments.sample,
      prescripteur: Prescripteur.order('RANDOM()').first,
      patient: patient
    )
  end
end

puts 'Ordonnances created.'




puts "Creating individual events..."

# Fetch some existing records to associate with events
therapists = Therapist.all
patients = Patient.all
services = Service.where(is_group: false) # Fetch only individual services
ordonnances = Ordonnance.all # Assuming Ordonnance records are present
statuses = ["non confirmée", "confirmé", "réalisé", "annulé", "non excusé"] # Possible status values

# Set the period for when the events will take place
starting_date = 7.days.ago.beginning_of_day # 7 days before today
ending_date = 14.days.from_now.beginning_of_day # 14 days after today

# Generate 10 time slots per day
event_times = (9..18).map { |hour| "#{hour}:00" }

therapists.each do |therapist|
  (starting_date.to_date..ending_date.to_date).each do |date|
    # Skip weekends
    next if date.saturday? || date.sunday?

    event_times.sample(10).each do |time|
      # Parse the date and time to create a valid DateTime object
      start_time = DateTime.parse("#{date} #{time}")
      end_time = start_time + services.sample.duration_per_unit.minutes # Use a sample service duration

      # Randomly assign a patient, a service, and an ordonnance for the sake of the example
      patient = patients.sample
      service = services.sample
      ordonnance = ordonnances.sample # Randomly select an ordonnance
      status = statuses.sample # Randomly select a status

      EventIndividuel.create!(
        therapist: therapist,
        patient: patient,
        ordonnance: ordonnance,
        service: service,
        start_date_time: start_time,  # Changed from start_date_time to start_time
        end_date_time: end_time,      # Changed from end_date_time to end_time
        status: status
        # ... any other attributes you need to set
      )
    end
  end
end

puts "Individual events created."



# AVAILABILITIES

puts "Creating week availabilities..."

days_of_week = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"]
therapists = Therapist.all

therapists.each do |therapist|
  week_availability = WeekAvailability.create!(
    therapist: therapist,
    valid_from: Date.new(2023, 1, 1),
    valid_until: Date.new(2023, 12, 31),
    name: "Standard"
  )
  days_of_week.each do |day|
    TimeBlock.create!(
      week_availability: week_availability,
      week_day: day,
      start_time: "08:00",
      end_time: "12:00",
      room: Room.all.sample
    )
    TimeBlock.create!(
      week_availability: week_availability,
      week_day: day,
      start_time: "13:00",
      end_time: "17:00",
      room: Room.all.sample
    )
  end
end

puts "#{WeekAvailability.count} week_availability created."
puts "#{TimeBlock.count} time_blocks created."
