require "rubygems"
require "sinatra"
require "sinatra/activerecord"

def get_db_for_env(rack_env)
  puts "Running in #{rack_env} mode..."
  return "db/development.db" unless rack_env
  mapping = {
    "development" => "db/development.db",
    "production" => "db/production.db",
    "test" => "db/test.db"
  }
  mapping[rack_env]
end

configure do
  ActiveRecord::Base.establish_connection(
                                          :adapter => 'sqlite3',
                                          :database => get_db_for_env(ENV["RACK_ENV"]))
end


set :public_folder, File.join(File.dirname(__FILE__), "public")
set :protection, :except => :frame_options
