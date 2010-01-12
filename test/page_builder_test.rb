require 'helper'
require 'lib/wonki/page_builder'
require 'lib/wonki/page_not_found'

class PageBuilderTest < Test::Unit::TestCase
  context "Building a Page" do
    setup do
      @builder = Wonki::PageBuilder.new("~/working/rubyyot-wiki-test")
    end
    
    should "include the location" do
      out = @builder.build("/cheese")
      assert_match("cheese", out[:content])
    end
    
    should "include the content" do
      out = @builder.build("/cheese")
      assert_match("swiss", out[:content])
    end
    
    should "flannel content" do
      out = @builder.build("/header")
      assert_match("<h2>foo</h2>", out[:content])
    end
    
    context "finding blob data" do
      should "find page contents in the git repo" do
	blob_data = @builder.find("foo")
	assert_match("bar bar", blob_data)
      end
    end
    
    context "last_modified date" do
      should "not be nil" do
	out = @builder.build("/foo")
	assert_not_nil out[:last_modified]
      end
      
      should "return the commited date" do
	out = @builder.build("/foo")
	assert_equal Time, out[:last_modified].class
      end
    end
    
    context "page doesn't exist" do
      should "throw page doesn't exist" do
	begin
	  @builder.find("walla-walla-bing-bang")
	  assert false, "Should have thrown a page not found exception"
	rescue Wonki::PageNotFound
	  assert true
	end
      end
    end
  end
end
