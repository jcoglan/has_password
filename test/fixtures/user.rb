class User < ActiveRecord::Base
  
  has_password :passwd, :salt_size => 16
  
end
