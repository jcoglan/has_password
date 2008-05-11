require 'test/unit'
require 'rubygems'
require 'active_record'
require File.dirname(__FILE__) + '/../init'
HasPassword::FORBIDDEN << 'chunky_bacon'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile => ':memory:'
require File.dirname(__FILE__) + '/fixtures/schema'
require File.dirname(__FILE__) + '/fixtures/user'

class HasPasswordTest < Test::Unit::TestCase
  
  def test_format_validation
    user = User.new
    user.password_hash = 'foo'
    assert !user.valid?
    user.password = 'foo'
    assert user.valid?
  end
  
  def test_salt_length
    assert_equal 4, User.salt_length
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
    
    user.update_attributes(:password => '')
    assert user.has_password?('nothing')
  end
  
  def test_plaintext
    user = User.create(:username => 'jcoglan', :password => 'foobarfoobar')
    assert_equal 'foobarfoobar', user.password
    user = User.find_by_username('jcoglan')
    assert_nil user.password
  end
  
  def test_blank_password_on_creation
    assert !User.create.valid?
    user = User.new(:password => '')
    assert !user.valid?
  end
  
  def test_forbidden_passwords
    user = User.new(:password => 'something')
    assert user.valid?
    user.password = 'thePaSSwoRD'
    assert !user.valid?
    assert user.errors.full_messages.include? "Password may not contain the string 'password'"
    user.password = 'chUNKy_bacON'
    assert !user.valid?
  end
  
  def test_after_change_callback
    user = User.create(:username => 'me', :password => 'something')
    assert_equal 0, user.count
    assert_equal 'me', user.username
    user.update_attributes(:username => 'james')
    assert_equal 0, user.count
    assert_equal 'james', user.username
    user.update_attributes(:password => 'nothing')
    assert_equal 1, user.count
    assert_equal 'changed', user.username
    3.times { user.save }
    assert_equal 1, user.count
    user.password = 'nothing'
    user.save
    assert_equal 1, user.count
    user.update_attributes(:password => 'something')
    assert_equal 2, user.count
  end
  
end
