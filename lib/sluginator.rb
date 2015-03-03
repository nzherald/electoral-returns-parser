require_relative 'sluginator/generator'

module Sluginator
  def self.included(base)
    base.before_validation Sluginator::Generator.new
    base.validates :slug, presence: true, uniqueness: true
  end
end
