module ActiveRecord
  class Base
    class << self
    private
      
      def has_password(field = :password, options = {})
        include HasPassword
        
        @password_field = field
        @salt_length = options[:salt_size] || 32
        
        attr_protected password_hash_field, password_salt_field
        
        validates_format_of password_hash_field, :with => /^[0-9a-f]{40}$/
        validates_format_of password_salt_field, :with => %r{^[a-z0-9]{#{@salt_length}}$}
        validates_confirmation_of :password
        
        validate do |passworded|
          unless passworded.password.blank?
            HasPassword::FORBIDDEN.each do |word|
              passworded.errors.add(:password, "may not contain the string '#{word}'") if
                  passworded.password =~ Regexp.new(word, Regexp::IGNORECASE)
            end
          end
        end
      end
      
    end
  end
end
