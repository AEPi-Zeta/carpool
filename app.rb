require 'sinatra'
require 'active_record'

require_relative 'models/master'

begin
  $CONFIG = YAML.load_file('config.yml').freeze
  $ROOT  = File.dirname(__FILE__)

  def assert_config(field)
    raise "The config file is missing #{field}" unless $CONFIG.has_key?(field)
  end

  assert_config(:connection)
rescue Exception => e
  puts e
  puts "The config file 'config.yml' was not found"
end

ActiveRecord::Base.establish_connection($CONFIG[:connection])

class Carpool < Sinatra::Base
  set :public_folder, $ROOT + '/public'

  configure do
  end

  require_relative 'routes/main'
end
