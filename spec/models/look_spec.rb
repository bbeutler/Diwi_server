require 'rails_helper'

RSpec.describe Look, type: :model do
  subject { build :look }

  it 'has a valid factory' do
    expect(build(:look)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:consumer) }
    it { is_expected.to have_many(:tags).through(:look_tags) }
    it { is_expected.to have_many(:photos) }
  end
end
