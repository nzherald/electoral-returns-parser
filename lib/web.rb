require_relative 'app'
require 'json'

class ElectoralReturnsApp < Sinatra::Base
  before do
    content_type :json, 'charset' => 'utf-8'
  end

  include CandidateRoutes
  include ElectorateRoutes
  include PartyRoutes
  include DonorRoutes

  get '/v1/donations.json' do
    JSON.pretty_generate Donation.all.map(&:as_json)
  end
end
