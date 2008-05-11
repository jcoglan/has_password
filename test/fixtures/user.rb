class User < ActiveRecord::Base
  
  has_password :passwd
  
end
