require 'rails_helper'

RSpec.describe Consumer, type: :model do
  subject { build :consumer }

  it 'has a valid factory' do
    expect(build(:consumer)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_one(:terms_acceptance) }
    it { is_expected.to have_many(:looks) }
  end
end
