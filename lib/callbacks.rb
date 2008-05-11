module HasPassword
  module Callbacks
  private
    
    def after_password_change(*callbacks, &block)
      callbacks << block if block_given?
      write_inheritable_array(:after_password_change, callbacks)
    end
    
    def self.extended(base)
      base.send :after_save do |m|
        m.instance_eval { @saved_password = @password }
      end
      
      base.send :after_update do |m|
        m.instance_eval do
          callback(:after_password_change) unless [nil, @saved_password].include?(@password)
        end
      end
    end
    
  end
end
