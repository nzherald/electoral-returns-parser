require 'bundler'
Bundler.require(:default, :web)
Dotenv.load
require 'sinatra/reloader'
require_relative 'sluginator'
require_relative 'presentable'

require_relative File.join 'presenters', 'base_presenter'

RELOADABLE_FILES = []
%w(models routes presenters).each do |dir|
  Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each do |f|
    require f
    RELOADABLE_FILES << f
  end
end

class ElectoralReturnsApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  configure :development do
    register Sinatra::Reloader
    also_reload './web.rb'
    also_reload './sluginator.rb'
    RELOADABLE_FILES.each { |f| also_reload f }
  end

  set :root, ElectoralReturnsApp.root
end
