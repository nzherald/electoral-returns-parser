DB = Sequel.connect(ENV['DATABASE_URL'])

class Donation < Sequel::Model

end
