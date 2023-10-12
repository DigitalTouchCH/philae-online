# db/seeds.rb

# Clear existing data to avoid conflicts (this line is optional and depends on your needs)
User.destroy_all
Therapist.destroy_all
Location.destroy_all

# ADMIN
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
)


# THERAPEUTES
user3 = User.create!(
  email: 'solen@centre-philae.ch',
  password: 'password123',
  password_confirmation: 'password123'
)
therapist3 = Therapist.create!(
  user: user3,
  first_name: 'Solen',
  last_name: 'Duclos',
  is_manager: true
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
  is_manager: false
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
  is_manager: false
)


# LOCATIONS & ROOMS

riponne = Location.create!(
  name: "Riponne",
  address: "Rue Saint-Laurent 19, 1003, Lausanne",
  acces_detail: "2e étage sonner à Espace 19"
)

# Ajout d'une salle pour Riponne
Room.create!(
  name: "Salle 1 à Riponne",
  location: riponne
)

joliette = Location.create!(
  name: "Centre Philae sous-gare",
  address: "Chemin de la joliette 2, 1006, Lausanne",
  acces_detail: "1er étage"
)

# Ajout de 5 salles pour Joliette
5.times do |i|
  Room.create!(
    name: "Salle #{i + 1} à Joliette",
    location: joliette
  )
end
