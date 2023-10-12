class Equipement < ApplicationRecord
  has_many :time_block

  validates :name, presence: true
end
