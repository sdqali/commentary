ENV["RACK_ENV"] = "test"

require "rubygems"
require "test/unit"
require "json"
require "rack"
require "rack/test"
require_relative "../app"

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def teardown
    Comment.delete_all
  end

  def test_knows_how_to_retrieve_comments
    4.times do
      Comment.create!({:nickname => "foo",
                        :content => "Test comment",
                        :domain => "example.com",
                        :document_path => "about/us"})
    end

    get "/comments", {:domain => "example.com", :document_path => "about/us"}
    assert last_response.ok?
    output = JSON.parse(last_response.body)
    assert_equal 4, output.size
    assert_equal "foo", output.first["nickname"]
    assert_equal "Test comment", output.first["content"]
  end
end
