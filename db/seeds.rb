require 'csv'
require_relative '../lib/app'
require 'pry'

csv = CSV.open(File.join(File.dirname(__FILE__), 'seeds', 'candidate_donations_2014.csv'), headers: true)

colours = {
  "National Party" => "#388cc3",
  "Labour Party" => "#ca1a1a",
  "Conservative" => "#39c9e7",
  "Internet Party" => "#64288C",
  "Independent" => "#ccc",
  "Māori Party" => "#db7e18",
  "New Zealand First Party" => "#000",
  "Green Party" => "#1ea951",
  "Democrats for Social Credit" => "#1A4935",
  "ACT New Zealand" => "#ffde00",
  "MANA Movement" => "#DD411B",
  "Focus New Zealand" => "#2390CB",
  "United Future" => "#5D0C59"
}

csv.each do |row|
  electorate = Electorate.find_or_create_by(name: row['electorate'])
  party = Party.find_or_create_by(name: row['party'], colour: colours[row['party']])
  last_name, first_names = row['candidate'].split(', ')
  candidate = Candidate.find_or_create_by(first_names: first_names, last_name: last_name, electorate: electorate, party: party)
  donor = Donor.find_or_create_by(name: row['name'])

  Donation.create(donor: donor, candidate: candidate, amount: row['amount'])
end

