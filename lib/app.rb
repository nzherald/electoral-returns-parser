require 'bundler'
Bundler.require(:default, :web)
Dotenv.load
%w[candidate donation donor electorate party].each { |f| require_relative "./models/#{f}" }

class ElectoralReturnsApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :root, ElectoralReturnsApp.root

end
