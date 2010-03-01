require 'helper'
require 'lib/wonki/wiki_page'


class WikiPageTest < Test::Unit::TestCase
  context "Returning a response" do
    setup do
      @page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test")
      @status, @headers, @body = @page.build_response("/foo")
    end

    should "have a status of 200" do
      assert_equal(200, @status)
    end

    should "set content type" do
      assert_equal("text/html; charset=utf-8", @headers["Content-Type"])
    end

    should "set content language" do
      assert_equal('en', @headers["Content-Language"])
    end

    #should "set last modified" do
    #  assert_equal(@headers["Last-Modified"], "Thu, 25 Feb 2010 00:50:16 GMT")
    #end

    should "set etag" do
      assert_not_nil @headers['Etag']
    end
  end

  context "caching" do
    should "not set if no info passed" do
      page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test")
      status, headers, body = page.build_response("/foo")

      assert_false(headers.has_key?("Cache-Control"))
    end

    should "set max age" do
      page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test", nil, :max_age => 300)
      status, headers, body = page.build_response("/foo")

      assert_equal("max-age=300", headers["Cache-Control"])
    end

    should "set response directive" do
      page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test", nil, :response_directive => 'public')
      status, headers, body = page.build_response("/foo")

      assert_equal("public", headers["Cache-Control"])
    end

    should "set both response directive and max_age when passed" do
      page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test", nil, :response_directive => 'public', :max_age => 20)
      status, headers, body = page.build_response("/foo")

      assert_equal("max-age=20, public", headers["Cache-Control"])
    end
  end

  context "Formatting" do
    setup do
      @page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test")
    end

    should "include the location" do
      out = @page.format_data :route_name => 'wonki', :content => 'this is cool'
      assert_match("wonki", out)
    end

    should "flannel content" do
      out = @page.format_data :route_name => 'test', :content => ':header_two:foo'
      assert_match("<h2>foo</h2>", out)
    end
  end

  context "PageNotFound" do
    setup do
      @page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test")
      @status, @headers, @body = @page.build_response("/pagenotfound")
    end

    should "have a status of 404" do
      assert_equal(404, @status)
    end
  end

  context "encoding" do
    setup do
      @page = Wonki::WikiPage.new("~/working/rubyyot-wiki-test")
      @status, @headers, @body = @page.build_response("/hiragana")
    end

    should "be encoded in UTF-8" do
      @body.each do |item|
        assert_equal(Encoding::UTF_8, item.encoding)
      end
    end

    should "have a status of 200" do
      assert_equal(200, @status)
    end
  end
end
