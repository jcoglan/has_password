require 'test/unit'
require 'rubygems'
require 'active_record'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile => ':memory:'
require File.dirname(__FILE__) + '/schema'
require File.dirname(__FILE__) + '/fixtures/user'

class HasPasswordTest < Test::Unit::TestCase
  
  def test_format_validation
    user = User.new
    user.passwd_hash = 'foo'
    assert !user.valid?
    user.password = 'foo'
    assert user.valid?
  end
  
  def test_confirmation
    user = User.create(:username => 'jcoglan', :password => 'foobarfoobar')
    user = User.find_by_username('jcoglan')
    assert user.valid?
    user.password = 'nothing'
    assert user.valid?
    user.password_confirmation = 'something'
    assert !user.valid?
    user.password_confirmation = 'nothing'
    assert user.valid?
  end
  
  def test_updating
    user = User.create(:username => 'jcoglan', :password => 'foobarfoobar')
    user = User.find_by_username('jcoglan')
    assert user.has_password?('foobarfoobar')
    assert !user.has_password?('nothing')
    assert user.update_attributes(:password => 'nothing')
    assert !user.has_password?('foobarfoobar')
    assert user.has_password?('nothing')
  end
  
  def test_plaintext
    user = User.create(:username => 'jcoglan', :password => 'foobarfoobar')
    assert_equal 'foobarfoobar', user.password
    user = User.find_by_username('jcoglan')
    assert_nil user.password
  end
  
end
