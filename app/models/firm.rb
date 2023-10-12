class Firm < ApplicationRecord
  has_many :therapists

  validates :name, presence: true
end
