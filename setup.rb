#! /usr/bin/env ruby

require "yaml"
require_relative "app"

module Commentary
  class Setup
    def self.initialize
      rack_env = ENV["RACK_ENV"] || "development"
      config = YAML::load(IO.read(File.join(File.dirname(__FILE__),
                                            "config",
                                            "#{rack_env}.yml")))

      site = Site.new
      site.name = config['name']
      site.domain = config['domain']
      site.save
    end
  end
end

Commentary::Setup.initialize
