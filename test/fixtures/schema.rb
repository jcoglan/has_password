ActiveRecord::Schema.define do
  
  create_table :users do |t|
    t.string :username
    t.string :password_hash
    t.string :password_salt
    t.integer :count
  end
  
end