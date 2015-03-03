class Donor < ActiveRecord::Base
  include Sluginator
  validates :name, presence: true

  has_many :donations
  has_many :candidates, through: :donations
end
