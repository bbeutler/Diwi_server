require 'rails_helper'

describe TermsAcceptance do
  it 'has a valid factory' do
    expect(build(:terms_acceptance)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :accepted_at }
    it { is_expected.to validate_presence_of :remote_ip }
    it { is_expected.to validate_presence_of :consumer }
  end

  describe 'associations' do
    it { is_expected.to belong_to :consumer }
  end
end