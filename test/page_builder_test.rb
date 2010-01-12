require 'helper'
require 'lib/wonki/page_builder'
require 'lib/wonki/page_not_found'

class PageBuilderTest < Test::Unit::TestCase
  context "Building a Page" do
    setup do
      @builder = Rubyyot::PageBuilder.new("~/working/rubyyot-wiki-test")
    end
    
    should "include the location" do
      out = @builder.build("/cheese")
      assert_match("cheese", out)
    end
    
    should "include the content" do
      out = @builder.build("/cheese")
      assert_match("swiss", out)
    end
    
    should "find page contents in the git repo" do
      out = @builder.find("foo")
      assert_match("bar bar", out)
    end
    
    should "flannel content" do
      out = @builder.build("/header")
      assert_match("<h2>foo</h2>", out)
    end
    
    context "page doesn't exist" do
      should "throw page doesn't exist" do
	begin
	  @builder.find("walla-walla-bing-bang")
	  assert false, "Should have thrown a page not found exception"
	rescue Rubyyot::PageNotFound
	  assert true
	end
      end
    end
  end
end
