class VideoPatient < ApplicationRecord
  belongs_to :patient
  belongs_to :video

  validates :valid_form, presence: true
  validates :valid_until, presence: true
  validate :valid_until_after_valid_form

  private

  def valid_until_after_valid_form
    return if valid_until.blank? || valid_form.blank?

    if valid_until <= valid_form
      errors.add(:valid_until, "must be after the valid from date")
    end
  end
end
