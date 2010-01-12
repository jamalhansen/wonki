require 'mime/types'
require 'grit'
require 'flannel'

module Wonki
  class PageBuilder
    def initialize(repo_path)
      @repo_path = repo_path
      @repository = Grit::Repo.new(@repo_path)
    end
    
    def build(route)
      route_name = route[1..-1] # strip leading slash
      data = find(route_name)
      mod_date = get_mod_date(route_name)
      content = %Q{<h2 id="location">#{route_name}</h2><div id="content">#{Flannel.quilt(data)}</div>}
      {:content => content, :last_modified => mod_date}
    end
    
    def find(name)
      blob = (@repository.tree/name)
      raise Wonki::PageNotFound.new if blob.nil?
      blob.data
    end
    
    def get_mod_date(name)
      @repository.commits.first.committed_date
    end
  end
end