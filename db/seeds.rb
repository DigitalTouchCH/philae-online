# db/seeds.rb
require 'roo'
require 'faker'

puts "Purging database..."

# Supprimer les enregistrements qui n'ont pas de dépendances
VideoPatient.destroy_all
EventPersonel.destroy_all
EventIndividuel.destroy_all
EventGroupe.destroy_all
PatientEventGroupe.destroy_all
Ordonnance.destroy_all
TherapistService.destroy_all
Video.destroy_all
WeekAvailability.destroy_all
Room.destroy_all
Location.destroy_all

# Supprimer les utilisateurs avant les thérapeutes
User.destroy_all
Therapist.destroy_all

# Supprimer les patients
Patient.destroy_all

# Supprimer les autres enregistrements
Firm.destroy_all
Service.destroy_all

puts "Database purged."




# ADMIN

puts "Creating admin users..."

user1 = User.create!(
  email: 'thomas.murat974@gmail.com',
  password: 'Lise974*-+',
  password_confirmation: 'Lise974*-+',
  is_admin: true,
  first_name: 'Thomas',
  last_name: 'Murat'
)
user2 = User.create!(
  email: 'duclos.solen@gmail.com',
  password: 'Lise974*-+',
  password_confirmation: 'Lise974*-+',
  is_admin: true,
  first_name: 'Solen',
  last_name: 'Duclos'
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
  password_confirmation: 'password123',
  first_name: 'Solen',
  last_name: 'Duclos'
)
therapist3 = Therapist.create!(
  first_name: 'Solen',
  last_name: 'Duclos',
  is_manager: true,
  firm: solen_duclos_ri,
  is_active: true
)
user4 = User.create!(
  email: 'amelie@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Amelie',
  last_name: 'Teil'
)
therapist4 = Therapist.create!(
  first_name: 'Amelie',
  last_name: 'Teil',
  is_manager: false,
  firm: solen_duclos_ri,
  is_active: true
)
user5 = User.create!(
  email: 'alexandre@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Alexandre',
  last_name: 'Dessert'
)
therapist5 = Therapist.create!(
  first_name: 'Alexandre',
  last_name: 'Dessert',
  is_manager: false,
  firm: solen_duclos_ri,
  is_active: true
)

user6 = User.create!(
  email: 'anne-laure@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Anne-Laure',
  last_name: 'Croquet'
)
therapist6 = Therapist.create!(
  first_name: 'Anne-Laure',
  last_name: 'Croquet',
  is_manager: true,
  firm: anne_laure_croquet_ri,
  is_active: true
)

user3.update(therapist: therapist3)
user4.update(therapist: therapist4)
user5.update(therapist: therapist5)
user6.update(therapist: therapist6)

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

# Liste des objectifs de physiothérapie
physiotherapy_objectives = [
  "Améliorer l'amplitude de mouvement et la flexibilité des articulations touchées.",
  "Renforcer les muscles supportant les articulations affectées pour réduire la douleur.",
  "Restaurer la fonctionnalité et l'indépendance dans les activités quotidiennes.",
  "Améliorer l'équilibre et la coordination pour prévenir les chutes.",
  "Accroître l'endurance cardiovasculaire pour une meilleure santé globale.",
  "Réduire l'inflammation et la douleur grâce à des techniques manuelles et de la cryothérapie.",
  "Favoriser la guérison des tissus mous après une blessure ou une chirurgie.",
  "Intégrer des exercices de respiration pour améliorer la fonction pulmonaire.",
  "Éduquer le patient sur les postures correctes pour minimiser la douleur au dos.",
  "Développer un programme personnalisé d'étirement et de renforcement pour prévenir les récidives.",
]

# Liste des plans de traitement
treatment_plans = [
  "Séances de kinésithérapie combinées à des exercices à domicile.",
  "Thérapie manuelle, y compris mobilisation articulaire et massage des tissus mous.",
  "Programme progressif de renforcement musculaire et d'entraînement à la stabilité.",
  "Utilisation de techniques de physiothérapie telles que l'ultrason et la stimulation électrique.",
  "Exercices d'aquathérapie pour une rééducation en douceur.",
  "Sessions de rééducation vestibulaire pour les problèmes d'équilibre.",
  "Thérapie par le mouvement pour améliorer la coordination et la fluidité des gestes.",
  "Entraînement proprioceptif pour renforcer les réflexes et la perception corporelle.",
  "Programme de réadaptation cardiorespiratoire pour améliorer l'endurance.",
  "Intégration de techniques de relaxation et de gestion de la douleur.",
]

# Liste des notes de progression
progress_notes = [
  "Le patient montre une amélioration significative de la mobilité articulaire.",
  "Réduction notable de la douleur suite aux sessions de thérapie manuelle.",
  "Le patient a atteint ses objectifs de renforcement musculaire initial.",
  "Amélioration constante de l'équilibre et de la coordination.",
  "Le patient rapporte une diminution de la douleur lors des activités quotidiennes.",
  "Progrès dans la capacité à effectuer des exercices d'étirement autonomes.",
  "Augmentation de l'endurance lors des séances d'exercice.",
  "Meilleure gestion de la douleur chronique grâce aux techniques enseignées.",
  "Le patient démontre une meilleure posture au travail et à la maison.",
  "Progression positive vers les objectifs de réadaptation après chirurgie.",
]

# Liste des diagnostics
diagnostics = [
  "Tendinite de la coiffe des rotateurs.",
  "Lombalgie due à une hernie discale.",
  "Syndrome du canal carpien.",
  "Arthrose du genou.",
  "Capsulite rétractile de l'épaule.",
  "Entorse de la cheville de grade II.",
  "Douleur cervicale post-traumatique.",
  "Fibromyalgie avec douleurs musculo-squelettiques généralisées.",
  "Bursite trochantérienne de la hanche.",
  "Sciatalgie secondaire à une compression nerveuse lombaire.",
]

# Liste des types d'ordonnance
types_of_ordonnance = ["Maladie", "Accident", "LaMal"]

# Assigner 0 à 3 ordonnances pour chaque patient
Patient.find_each do |patient|
  num_of_ordonnances = [0, 1, 1, 2, 2, 3].sample
  next if num_of_ordonnances == 0

  num_of_ordonnances.times do
    Ordonnance.create!(
      date_prescription: Faker::Date.between(from: 1.year.ago, to: Date.today),
      num_of_session: rand(1..10),
      title: ordonnance_titles.sample,
      commentaire: ordonnance_comments.sample,
      prescripteur: Prescripteur.order('RANDOM()').first,
      patient: patient,
      physiotherapy_objectiv: physiotherapy_objectives.sample,
      treatment_plan: treatment_plans.sample,
      progress_notes: progress_notes.sample,
      diagnostic: diagnostics.sample,
      type_of_ordonnance: types_of_ordonnance.sample,
      is_domicile: [true, false].sample # Aléatoirement choisi
    )
  end
end

puts 'Ordonnances created.'




puts "Creating individual events..."

# Fetch some existing records to associate with events
therapists = Therapist.all
patients = Patient.all
services = Service.where(is_group: false) # Fetch only individual services
statuses = ['à confirmer', 'confirmé', 'réalisé', 'non excusé', 'excusé'] # Possible status values

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
      service = services.sample
      end_time = start_time + service.duration_per_unit.minutes

      # Randomly assign a patient who has an ordonnance
      patient = patients.select { |p| p.ordonnances.any? }.sample

      # Select one of the patient's ordonnances if available
      ordonnance = patient.ordonnances.sample if patient
      status = statuses.sample

      # Create event only if a patient with ordonnance is selected
      if patient && ordonnance
        EventIndividuel.create!(
          therapist: therapist,
          patient: patient,
          ordonnance: ordonnance,
          service: service,
          start_date_time: start_time,
          end_date_time: end_time,
          status: status
          # ... any other attributes you need to set
        )
      end
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
