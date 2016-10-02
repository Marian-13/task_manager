class Task < ApplicationRecord
  validates :name, presence: true

  has_many :line_items, dependent: :destroy
  has_many :users, through: :line_items

  def another_user_email

  end
end
