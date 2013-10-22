require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }
  it { should validate_uniqueness_of(:ending) }

  it { should validate_presence_of(:ending) }
  it { should have_many(:users)}


end