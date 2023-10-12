class Service < ApplicationRecord
  has_many :event_groupes
  has_many :event_individuels
  has_many :therapist_services
  has_many :therapists, through: :therapist_services

  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :duration_per_unit, numericality: { only_integer: true, greater_than_or_equal_to: 10 }, allow_nil: true
  validates :is_group, inclusion: { in: [true, false] }
end
