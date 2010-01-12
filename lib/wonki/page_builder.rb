require 'mime/types'
require 'grit'
require 'flannel'

module Wonki
  class PageBuilder
    def initialize(repo_path)
      @repo_path = repo_path
    end
    
    def build(route)
      route_name = route[1..-1]
      data = find(route[1..-1])
      %Q{<h2 id="location">#{route_name}</h2><div id="content">#{Flannel.quilt(data)}</div>}
    end
    
    def find(name)
      repository = Grit::Repo.new(@repo_path)
      blob = (repository.tree/name)
      raise Wonki::PageNotFound.new if blob.nil?
      blob.data
    end
  end
end