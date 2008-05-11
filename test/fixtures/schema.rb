ActiveRecord::Schema.define do
  
  create_table :users do |t|
    t.string :username, :length => 255, :null => false
    t.string :passwd_hash
    t.string :passwd_salt
  end
  
end