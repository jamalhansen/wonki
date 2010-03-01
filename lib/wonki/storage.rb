# encoding: UTF-8

require 'mime/types'
require 'grit'

module Wonki
  class Storage
    def initialize(repo_path)
      @repo_path = repo_path
      @repository = Grit::Repo.new(@repo_path)
    end

    def build(route)
      route_name = route[1..-1] # strip leading slash
      data = find(route_name)
      mod_date = get_mod_date(route_name)
      {:content => data, :last_modified => mod_date, :route_name => route_name}
    end

    def find(name)
      blob = (@repository.tree/name)
      raise Wonki::PageNotFound.new if blob.nil?
      blob.data
    end

    def get_mod_date(name)
      @repository.commits.first.committed_date  # date of the last commit to the repo.
    end
  end
end