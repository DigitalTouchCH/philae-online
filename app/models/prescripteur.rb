class Prescripteur < ApplicationRecord
  has_many :ordonnances

  validates :name, presence: true
end
