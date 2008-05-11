module ActiveRecord
  class Base
    class << self
    private
      
      def has_password(field = :password, options = {})
        include HasPassword
        
        @password_field = field
        @salt_length = ((options[:salt_size] || 32) / 4).ceil
        
        attr_protected password_hash_field, password_salt_field
        
        validates_format_of password_hash_field, :with => /^[0-9a-f]{40}$/
        validates_format_of password_salt_field, :with => %r{^[0-9a-f]{#{@salt_length}}$}
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
