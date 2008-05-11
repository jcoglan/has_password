require 'digest/sha1'

module HasPassword
  
  FORBIDDEN = %w(password user system test admin)
  
  # Returns a random string of the given length
  def self.random_hex(length = 8)
    chars = '0123456789abcdef'
    (1..length).map { |i| chars[ rand(chars.length) ].chr }.join('')
  end
  
  # Returns the SHA1 hash of the string with the given salt
  def self.encrypt(string, salt = '')
    hashable = "#{salt}#{string}"
    Digest::SHA1.hexdigest(hashable)
  end
  
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
  
  module InstanceMethods
    # Returns the current plain-text password if it is available
    def password
      @password
    end
    
    # Sets the password to the given plain-text value
    def password=(pwd)
      @password = pwd.to_s
      salt = HasPassword.random_hex(self.class.salt_length)
      send "#{self.class.password_salt_field}=", salt
      send "#{self.class.password_hash_field}=", HasPassword.encrypt(@password, salt)
    end
    
    # Returns +true+ iff the user has the given password
    def has_password?(pwd)
      hash, salt = %w(hash salt).map { |f| send self.class.send("password_#{f}_field") }
      hash == HasPassword.encrypt(pwd, salt)
    end
  end
  
  module ClassMethods
    def password_hash_field
      "#{@password_field}_hash"
    end
    
    def password_salt_field
      "#{@password_field}_salt"
    end
    
    def salt_length
      @salt_length
    end
  end
  
end
