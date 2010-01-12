require 'wonki/page_builder'
require 'wonki/page_not_found'

module Wonki
  class WikiPage
    def initialize(repo_path)
      @repo_path = repo_path
    end
    
    def call(env)
      req = Rack::Request.new(env)
      build_response(req.path)
    end 
    
    def build_response(path)
      path = "/home" if path == "/"
      builder = Wonki::PageBuilder.new(@repo_path)
            
      begin
	response_body = builder.build(path)
	status = 200
      rescue Wonki::PageNotFound
	response_body = "Page Not Found"
	status = 404
      rescue e
	response_body = "Server Error: #{e.message}\r\n#{e.stack_trace}"
	status = 500
      end
      
      headers = {"Content-Type" => "text/html", "Content-Language" => "en"}

      [status, headers, response_body] 
    end
  end   
end
