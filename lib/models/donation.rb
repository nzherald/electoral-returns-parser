class Donation < ActiveRecord::Base
  include Presentable
  validates :amount, presence: true, numericality: { greater_than: 0 }

  belongs_to :donor
  belongs_to :candidate
end
