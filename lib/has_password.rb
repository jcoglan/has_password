require 'digest/sha1'

module HasPassword
  
  # Returns a random string of the given length
  def self.random_string(length = 8)
    chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    (1..length).map { |i| chars[ rand(chars.length) ].chr }.join('')
  end
  
  # Returns the SHA1 hash of the string with the given salt
  def self.encrypt(string, salt = '')
    hashable = "#{string}#{salt}"
    Digest::SHA1.hexdigest(hashable)
  end
  
end
