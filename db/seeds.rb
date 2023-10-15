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
Room.destroy_all
TimeBlock.destroy_all
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

filtered_names.each do |first_name, last_name|
  Patient.create!(
    first_name: first_name,
    last_name: last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 80)
    # ... any other patient data you want to import
  )
end

puts "Patients imported."
