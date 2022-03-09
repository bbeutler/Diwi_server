require 'rails_helper'

RSpec.describe Photo, type: :model do
  subject { build :photo }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:look) }

    it 'is expected to validate the presence of an image for the photo' do
      bad_photo = build(:photo, image: nil)
      expect(bad_photo).to be_invalid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:look) }
  end
end
