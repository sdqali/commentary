require "rubygems"
require "sinatra"

require_relative "config"
require_relative "models/comment"
require_relative "models/site"

include Commentary

def app_headers
  {
    "Content-Type" => "application/json"
  }
end


get "/comments.json" do
  return [422,
          app_headers,
          [{:error => "The domain and document_path must be specified."}.to_json]] unless (params["domain"] && params["document_path"])
  site = Site.find_by_domain(params["domain"])
  return [404, app_headers, {:error => "Commentary is not configured for this domain."}.to_json] unless site
  comments = Comment.where({
                             :site_id => site.id,
                             :document_path => params["document_path"]
                           }).to_a
  output = comments.map do |c|
    {
      :content => c.content,
      :nickname => c.nickname,
      :timestamp => c.created_at.to_s
    }
  end

  [200, app_headers, [output.to_json]]
end

post "/comments.json" do
  raw_json = request.body.read
  begin
    comment_hash = JSON.parse(raw_json)
    site = Site.find_by_domain(comment_hash["domain"])
    return [422, app_headers, [{:error => "The Site provided is not valid."}.to_json]] unless site
    comment = Comment.create!({
                                :content => comment_hash["content"],
                                :nickname => comment_hash["nickname"],
                                :document_path => comment_hash["document_path"],
                                :site_id => site.id
                              })

  rescue JSON::ParserError
    return [422, app_headers, [{:error => "The JSON provided is not valid."}.to_json]]
  rescue ActiveRecord::RecordInvalid => e
    return [422, app_headers, [{:error => e.message}.to_json]]
  end

  [201, app_headers, [comment.to_json]]
end

get "/comment_frame" do
  domain = params["domain"]
  document_path = params["document_path"]
  rendered_content = IO.read(File.join("public", "comment_frame.html"))
    .gsub("%DOMAIN%", "\"#{domain}\"")
    .gsub("%DOCUMENT_PATH%", "\"#{document_path}\"")

  [
   200,
   {
     "Content-Type" => "text/html",
     "Access-Control-Allow-Origin" => domain
   },
   [rendered_content]
  ]
end
