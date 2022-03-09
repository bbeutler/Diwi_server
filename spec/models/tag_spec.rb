require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { build :tag }

  it 'has a valid factory' do
    expect(build(:tag)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:consumer) }
    it do
      is_expected.to validate_uniqueness_of(:title)
        .case_insensitive
        .scoped_to(:consumer_id)
        .with_message('has already been taken')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:consumer) }
    it { is_expected.to have_many(:looks).through(:look_tags) }
  end
end
