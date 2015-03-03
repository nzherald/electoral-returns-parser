class Candidate < ActiveRecord::Base
  include Sluginator
  include Presentable
  validates :first_names, :last_name, presence: true

  has_many :donations
  has_many :donors, through: :donations
  belongs_to :electorate
  belongs_to :party

  def donations_list
    donations.map do |d|
      { name: d.donor.name, amount: d.amount }
    end
  end

  def donation_amounts
    donations.pluck(:amount)
  end

  def total_donations
    donation_amounts.sum
  end

  def name
    "#{first_names} #{last_name}"
  end

end
