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

  def test_responds_with_422_if_domain_not_specified
    get "/comments", {:document_path => "about/us"}
    assert_equal 422, last_response.status
    assert_equal "The domain and document_path must be specified", last_response.body
  end

  def test_responds_with_422_if_document_path_not_specified
    get "/comments", {:domain => "example.com"}
    assert_equal 422, last_response.status
    assert_equal "The domain and document_path must be specified", last_response.body
  end

  def test_know_how_to_add_comment
    request_body = {
      :nickname => "foo",
      :content => "Test comment",
      :domain => "example.com",
      :document_path => "about/us"
    }.to_json
    post "/comments", request_body
    assert_equal 201, last_response.status
    assert_equal 1, Comment.all.size
  end

  def test_does_not_create_comment_if_params_not_sent
    post "/comments"
    assert_equal 422, last_response.status
    assert_equal "The JSON provided is not valid.", last_response.body
    assert_equal 0, Comment.all.size
  end

  def test_does_not_create_comment_if_not_valid_data
    request_body = {
      :content => "Test comment",
      :domain => "example.com",
      :document_path => "about/us"
    }.to_json
    post "/comments", request_body
    assert_equal 422, last_response.status
    assert_equal "Validation failed: Nickname can't be blank", last_response.body
    assert_equal 0, Comment.all.size
  end

  def test_serves_static_files
    get "/commentary.js"
    assert last_response.ok?
  end
end
