require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'wonki'

class Test::Unit::TestCase
  def assert_false assertion
    assert !assertion
  end
end
