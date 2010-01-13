require 'wonki/page_builder'
require 'wonki/page_not_found'

module Wonki
  class WikiPage
    def initialize(repo_path, max_age=nil)
      @max_age = max_age
      @repo_path = repo_path
    end
    
    def call(env)
      req = Rack::Request.new(env)
      build_response(req.path)
    end 
    
    def build_response(path)
      path = "/home" if path == "/"
      builder = Wonki::PageBuilder.new(@repo_path)
            
      headers = {"Content-Type" => "text/html", "Content-Language" => "en"}
      
      begin
	git_data = builder.build(path)
	response_body = git_data[:content]
	headers["Last-Modified"] = git_data[:last_modified].httpdate
	headers["Etag"] = Digest::MD5.hexdigest(git_data[:content])
	headers["Cache-Control"] = set_cache_control
	status = 200
      rescue Wonki::PageNotFound
	response_body = "Page Not Found"
	status = 404
      rescue RuntimeError => e
	response_body = "Server Error: #{e.message}\r\n#{e.stack_trace}"
	status = 500
      end
      
      [status, headers, response_body] 
    end
    
    def set_cache_control
      return "max-age=#{@max_age}, public" if @max_age
      "public"
    end
  end   
end
