class Therapist < ApplicationRecord
  belongs_to :user
  belongs_to :firm

  has_many :event_groupes
  has_many :event_individuels
  has_many :event_personels
  has_many :therapist_services
  has_many :services, through: :therapist_services
  has_many :videos
  has_many :week_availabilities

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :is_manager, inclusion: { in: [true, false] }
end
