require "yaml"
require_relative "app"

module Commentary
  class Setup
    def self.initialize
      rack_env = ENV["RACK_ENV"]
      config = YAML.load(File.join(File.dirname(__FILE__),
                                   "..",
                                   "config",
                                   "#{rack_env}.yml"))
      Site.create!({
                     :name => config['name'],
                     :domain => config['domain']
                   })
    end
  end
end

Commentary::Setup.initialize
