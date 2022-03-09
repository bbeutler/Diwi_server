require 'rails_helper'

RSpec.describe Device, type: :model do
  subject { build :device }

  it 'has a valid factory' do
    expect(build(:device)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:device_token) }
    it { is_expected.to validate_presence_of(:platform) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:consumer) }
  end
end
