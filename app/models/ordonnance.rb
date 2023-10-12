class Ordonnance < ApplicationRecord
  belongs_to :prescripteur
  belongs_to :patient

  has_many :event_individuels
  has_many :patient_event_groupes

  validates :date_prescription, presence: true
  validates :num_of_session, numericality: { only_integer: true, greater_than: 0 }

end
