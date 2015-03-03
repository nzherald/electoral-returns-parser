class Party < ActiveRecord::Base
  include Sluginator
  validates :name, presence: true

  has_many :candidates
end
