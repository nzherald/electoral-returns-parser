class Donor < ActiveRecord::Base
  validates :name, presence: true

  has_many :donations
  has_many :candidates, through: :donations
end
