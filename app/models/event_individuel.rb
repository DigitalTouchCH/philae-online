class EventIndividuel < ApplicationRecord
  belongs_to :therapist
  belongs_to :patient
  belongs_to :ordonnance, optional: true
  belongs_to :service

  validates :therapist_id, presence: true
  validates :patient_id, presence: true
  validates :service_id, presence: true
  validates :status, presence: true, inclusion: { in: ['à confirmer', 'confirmé', 'réalisé', 'non excusé', 'excusé'] }

  STATUSES = ['à confirmer', 'confirmé', 'réalisé', 'non excusé', 'excusé'].freeze

  def self.statuses
    STATUSES
  end

end
