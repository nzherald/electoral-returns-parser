class Donor < ActiveRecord::Base
  include Sluginator
  include Presentable
  validates :name, presence: true

  has_many :donations
  has_many :candidates, through: :donations

  def donations_list
    donations.map do |d|
      {
        candidate: d.candidate.name,
        candidate_id: d.candidate.slug,
        amount: d.amount
      }
    end
  end

  def donation_amounts
    donations.pluck(:amount)
  end

  def total_donations
    donation_amounts.sum
  end
end
