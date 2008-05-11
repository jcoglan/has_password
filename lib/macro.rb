module ActiveRecord
  class Base
    class << self
    private
      
      def has_password(options = {})
        include HasPassword
        
        # Store salt size in chars rather than bits. One hex char == 4 bits
        @salt_length = ((options[:salt_size] || 24) / 4.0).ceil
        
        attr_protected :password_hash, :password_salt
        
        validates_format_of :password_hash, :with => /^[0-9a-f]{40}$/
        validates_format_of :password_salt, :with => %r{^[0-9a-f]{#{@salt_length}}$}
        validates_confirmation_of :password
        
        validate do |m|
          unless m.password.blank?
            HasPassword::FORBIDDEN.each do |word|
              m.errors.add(:password, "may not contain the string '#{word}'") if
                  m.password =~ Regexp.new(word, Regexp::IGNORECASE)
            end
          end
          
          m.errors.add(:password, 'must not be blank') if m.new_record? and m.password.blank?
        end
      end
      
    end
  end
end
