class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  
  has_secure_password
end
