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
    Site.delete_all
  end

  def test_knows_how_to_retrieve_comments
    blog = Site.create!({
                          :name => "Blog",
                          :domain => "blog.example.com"
                        })
    4.times do
      Comment.create!({:nickname => "foo",
                        :content => "Test comment",
                        :document_path => "about/us",
                        :site_id => blog.id})
    end

    get "/comments.json", {:domain => "blog.example.com", :document_path => "about/us"}
    assert last_response.ok?
    output = JSON.parse(last_response.body)
    assert_equal 4, output.size
    assert_equal "foo", output.first["nickname"]
    assert_equal "Test comment", output.first["content"]
  end

  def test_responds_with_422_if_domain_not_specified
    get "/comments.json", {:document_path => "about/us"}
    assert_equal 422, last_response.status
    assert_match "The domain and document_path must be specified", last_response.body
  end

  def test_responds_with_422_if_document_path_not_specified
    get "/comments.json", {:domain => "example.com"}
    assert_equal 422, last_response.status
    assert_match "The domain and document_path must be specified", last_response.body
  end

  def test_know_how_to_add_comment
    blog = Site.create!({
                          :name => "Blog",
                          :domain => "blog.example.com"
                        })
    request_body = {
      :nickname => "foo",
      :content => "Test comment",
      :domain => "blog.example.com",
      :document_path => "about/us"
    }.to_json
    post "/comments.json", request_body
    assert_equal 201, last_response.status
    assert_equal 1, Comment.all.size
  end

  def test_does_not_create_comment_if_params_not_sent
    post "/comments.json"
    assert_equal 422, last_response.status
    assert_match "The JSON provided is not valid.", last_response.body
    assert_equal 0, Comment.all.size
  end

  def test_does_not_create_comment_if_not_valid_data
    blog = Site.create!({
                          :name => "Blog",
                          :domain => "blog.example.com"
                        })

    request_body = {
      :content => "Test comment",
      :document_path => "about/us",
      :nickname => "foo"
    }.to_json
    post "/comments.json", request_body
    assert_equal 422, last_response.status
    assert_match "The Site provided is not valid.", last_response.body
    assert_equal 0, Comment.all.size
  end

  def test_serves_static_files
    get "/commentary.js"
    assert last_response.ok?
  end

  def test_ensure_correct_content_type
    post "/comments.json", {:foo => :bar}
    assert_equal "application/json", last_response.headers["Content-Type"]
  end

  def test_ensure_correct_content_type
    get "/comments.json", {:foo => :bar}
  end

  def test_renders_comment_frame_as_a_template_with_values
    get "/comment_frame", {:domain => "foo", :document_path => "/bar"}
    assert_match /domain: \"foo\"/, last_response.body
    assert_match /documentPath: \"\/bar\"/, last_response.body
    assert_equal "*", last_response.headers["Access-Control-Allow-Origin"]
  end
end
