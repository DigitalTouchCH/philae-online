class TherapistService < ApplicationRecord
  belongs_to :therapist
  belongs_to :service

  validates :therapist_id, presence: true
  validates :service_id, presence: true
end
