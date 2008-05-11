class User < ActiveRecord::Base
  
  has_password :salt_size => 16
  
end
