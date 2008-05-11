class User < ActiveRecord::Base
  
  has_password :salt_size => 16
  
  before_validation do |m|
    m.count ||= 0
  end
  
  after_password_change :increment!
  
  def increment!
    self.count = count + 1
  end
  
  after_password_change do |m|
    m.username = 'changed'
  end
  
end
