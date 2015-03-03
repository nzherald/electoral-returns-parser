class Party < ActiveRecord::Base
  include Sluginator
  include Presentable

  validates :name, presence: true
  has_many :candidates
end
