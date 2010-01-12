require 'helper'
require 'lib/wonki/wiki_page'


class WikiPageTest < Test::Unit::TestCase
  context "Returning a response" do
    setup do
      @page = Rubyyot::WikiPage.new("~/working/rubyyot-wiki-test")
      @status, @headers, @body = @page.build_response("/foo")
    end
    
    should "have a status of 200" do
      assert_equal(200, @status)
    end
    
    should "set content type" do
      assert_equal(@headers["Content-Type"], "text/html")
    end
    
    should "set content language" do
      assert_equal(@headers["Content-Language"], 'en')
    end
  end
  
  context "PageNotFound" do
    setup do
      @page = Rubyyot::WikiPage.new("~/working/rubyyot-wiki-test")
      @status, @headers, @body = @page.build_response("/pagenotfound")
    end
    
    should "have a status of 404" do
      assert_equal(404, @status)
    end
  end
end
