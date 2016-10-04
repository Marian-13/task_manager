class User < ApplicationRecord
  before_save { self.email.downcase! }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true,
                    format: { with: EMAIL_REGEX }

  has_secure_password

  has_many :line_items
  has_many :tasks, through: :line_items
end
