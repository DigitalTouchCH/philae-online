class Room < ApplicationRecord
  belongs_to :location
  has_many :time_block

  validates :name, presence: true
end
