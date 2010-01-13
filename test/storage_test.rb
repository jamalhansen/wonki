require 'helper'
require 'lib/wonki/storage'
require 'lib/wonki/page_not_found'

class StorageTest < Test::Unit::TestCase
  context "Building a Page" do
    setup do
      @storage = Wonki::Storage.new("~/working/rubyyot-wiki-test")
    end
    
    should "include the content" do
      out = @storage.build("/cheese")
      assert_match("swiss", out[:content])
    end
    
    context "finding blob data" do
      should "find page contents in the git repo" do
	blob_data = @storage.find("foo")
	assert_match("bar bar", blob_data)
      end
    end
    
    context "last_modified date" do
      should "not be nil" do
	out = @storage.build("/foo")
	assert_not_nil out[:last_modified]
      end

      should "return the commited date" do
	out = @storage.build("/foo")
	assert_equal Time, out[:last_modified].class
      end
    end
    
    context "page doesn't exist" do
      should "throw page doesn't exist" do
	begin
	  @storage.find("walla-walla-bing-bang")
	  assert false, "Should have thrown a page not found exception"
	rescue Wonki::PageNotFound
	  assert true
	end
      end
    end
  end
end
