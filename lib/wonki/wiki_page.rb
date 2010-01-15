require 'wonki/storage'
require 'wonki/page_not_found'
require 'flannel'
require 'flannel/file_cache'

module Wonki
  class WikiPage
    def initialize(repo_path, flannel_cache=nil, cache_control=nil)
      @cache_control = cache_control
      @repo_path = repo_path
      @flannel_cache = Flannel::FileCache.new(File.expand_path(flannel_cache)) if flannel_cache
    end
    
    def call(env)
      req = Rack::Request.new(env)
      build_response(req.path)
    end 
    
    def build_response(path)
      path = "/home" if path == "/"
      storage = Wonki::Storage.new(@repo_path)
            
      headers = {"Content-Type" => "text/html", "Content-Language" => "en"}
      
      begin
	git_data = storage.build(path)
	response_body = format_data(git_data)
	headers["Last-Modified"] = git_data[:last_modified].httpdate
	headers["Etag"] = Digest::MD5.hexdigest(git_data[:content])
	headers = set_cache_control headers
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
    
    def format_data data
      if @flannel_cache
	output = Flannel.quilt(data[:content], :cache => @flannel_cache)
      else
	output = Flannel.quilt(data[:content])
      end
      
      %Q{<h2 id="location">#{data[:route_name]}</h2><div id="content">#{output}</div>}
    end
    
    def set_cache_control headers
      return headers unless @cache_control
      
      if @cache_control[:max_age]
	if @cache_control[:response_directive]
	  headers["Cache-Control"] = "max-age=#{@cache_control[:max_age]}, #{@cache_control[:response_directive]}"
	else
	  headers["Cache-Control"] = "max-age=#{@cache_control[:max_age]}"
	end
      else
	if @cache_control[:response_directive]
	  headers["Cache-Control"] = @cache_control[:response_directive]
	end
      end
  
      headers
    end
  end   
end
