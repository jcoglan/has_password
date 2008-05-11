require 'digest/sha1'

module HasPassword
  
  FORBIDDEN = %w(password user system test admin)
  
  # Returns a random string of the given length
  def self.random_hex(length = 8)
    (1..length).map { |i| rand(16).to_s(16) }.join('')
  end
  
  # Returns the SHA1 hash of the string with the given salt
  def self.encrypt(string, salt = '')
    hashable = "#{salt}#{string}"
    Digest::SHA1.hexdigest(hashable)
  end
  
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :extend, Callbacks
  end
  
  module InstanceMethods
    # Returns the current plain-text password if it is available
    def password
      @password
    end
    
    # Sets the password to the given plain-text value
    def password=(pwd)
      return if pwd.blank?
      @password = pwd.to_s
      salt = HasPassword.random_hex(self.class.salt_length)
      self.password_salt = salt
      self.password_hash = HasPassword.encrypt(@password, salt)
    end
    
    # Returns +true+ iff the user has the given password
    def has_password?(pwd)
      password_hash == HasPassword.encrypt(pwd, password_salt)
    end
  end
  
  module ClassMethods
    def salt_length
      @salt_length
    end
  end
  
end
