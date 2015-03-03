require 'csv'
require_relative '../lib/app'
require 'pry'

csv = CSV.open(File.join(File.dirname(__FILE__), 'seeds', 'candidate_donations_2014.csv'), headers: true)

csv.each do |row|
  electorate = Electorate.find_or_create_by(name: row['electorate'])
  party = Party.find_or_create_by(name: row['party'])
  last_name, first_names = row['candidate'].split(', ')
  candidate = Candidate.find_or_create_by(first_names: first_names, last_name: last_name, electorate: electorate, party: party)
  donor = Donor.find_or_create_by(name: row['name'])

  Donation.create(donor: donor, candidate: candidate, amount: row['amount'])
end
