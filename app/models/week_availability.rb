class WeekAvailability < ApplicationRecord
  has_many :time_blocks, dependent: :destroy
  belongs_to :therapist

  validates :valid_from, presence: true
  validates :valid_until, presence: true
  validate :valid_until_after_valid_from

  private

  def valid_until_after_valid_from
    return if valid_until.blank? || valid_from.blank?

    if valid_until <= valid_from
      errors.add(:valid_until, "must be after the valid from date")
    end
  end
end
