require 'csv'
require 'pry'

module Parser
  Donation = Struct.new(:to, :name, :amount)

  def self.run
    candidate_donations = CSV.read('candidate_donations_2014.csv', headers: true)

    donations = []

    verification_keys = candidate_donations.headers.select {|h| h.match(/_verified$/) }

    candidate_donations.each do |row|
      candidate = row['Document Title']
      next unless verification_keys.map {|v| row[v] }.uniq == ["true"] # only choose rows where we accept all answers
      next if donations.detect { |d| d.to == candidate } # next if we have already done this candidate
      (1..10).each do |i|
        name = row["answer_Donor name #{i}"]
        amount = row["answer_Donation amount #{i}"].gsub(/\$|,/, '').to_f
        next if name == 'nil'

        donations << Donation.new(candidate, name, amount)
      end
    end

    # national_donations = donations.select {|d| d.name =~ /National/ }
    # puts national_donations.map(&:amount).inject(0, &:+)

    CSV.open 'candidate_donations_clean_2014.csv', 'wb' do |csv|
      csv << ['candidate', 'name', 'amount']
      donations.each do |d|
        csv << d.entries
      end
    end

    puts 'Done'
  end
end

Parser.run
