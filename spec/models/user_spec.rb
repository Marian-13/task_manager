require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(25) }

  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email).is_at_most(100) }
  it { should validate_uniqueness_of(:email) }

  it 'should not be valid if email does not match format' do
    valid_emails = ["user01@email.com",
                    "USER01@ukr.net",
                    "user_user_01@gmail.com",
                    "2132142@yahoo.com"]

    valid_emails.each do |email|
      expect(email =~ User::EMAIL_REGEX).to_not be_nil
    end

    invalid_emails = ["123", "user01@emailcom"]

    invalid_emails.each do |email|
      expect(email =~ User::EMAIL_REGEX).to be_nil
    end
  end

  it { should have_secure_password }

  it { should have_many(:line_items) }
  it { should have_many(:tasks).through(:line_items) }
end
