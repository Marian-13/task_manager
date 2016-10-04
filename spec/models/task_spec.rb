require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:description).is_at_most(250) }

  it { should have_many(:line_items).dependent(true) }
  it { should have_many(:users).through(:line_items) }
end
