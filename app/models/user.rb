class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :therapist, optional: true
  belongs_to :patient, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
end
