class PatientEventGroupe < ApplicationRecord

  belongs_to :patient
  belongs_to :event_groupe
  belongs_to :ordonnance

  validates :patient_id, presence: true
  validates :event_groupe_id, presence: true
  validates :status, presence: true, inclusion: { in: ["non confirmée", "confirmé", "réalisé", "annulé", "non excusé" ] }
end
