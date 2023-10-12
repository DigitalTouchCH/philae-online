class EventGroupe < ApplicationRecord
  belongs_to :therapist
  belongs_to :service

  has_many :event_groupe_patients
  has_many :patients, through: :event_groupe_patients

  validates :therapist_id, presence: true
  validates :max_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: ["non confirmée", "confirmé", "réalisé", "annulé" ] }
end
