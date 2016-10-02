class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true,
                    format: { with: EMAIL_REGEX }

  has_secure_password

  has_many :line_items, dependent: :destroy
  has_many :tasks, through: :line_items
end
