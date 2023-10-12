class EventPersonel < ApplicationRecord
  belongs_to :therapist

  validates :start_date_time, presence: true
  validates :end_date_time, presence: true
  validates :is_paid_holiday, inclusion: { in: [true, false] }
  validate :end_after_start

  private

  def end_after_start
    return if end_date_time.blank? || start_date_time.blank?

    if end_date_time <= start_date_time
      errors.add(:end_date_time, "doit être après le début")
    end
  end

end
