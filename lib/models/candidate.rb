class Candidate < ActiveRecord::Base
  validates :first_names, :last_name, presence: true

  has_many :donations
  has_many :donors, through: :donations
  belongs_to :electorate
  belongs_to :party
end
