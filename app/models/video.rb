class Video < ApplicationRecord
  belongs_to :therapist
  has_many :video_patients
  has_many :patients, through: :video_patients

  validates :title, presence: true
  validates :url, presence: true, format: { with: /\Ahttps?:\/\/[\S]+/i, message: "must be a valid URL" }
end
