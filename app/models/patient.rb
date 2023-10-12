class Patient < ApplicationRecord
  has_many :event_individuels
  has_many :patient_event_groupes
  has_many :event_groupes, through: :patient_event_groupes
  has_many :ordonnances
  has_many :video_patients
  has_many :videos, through: :video_patients

  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true
end
