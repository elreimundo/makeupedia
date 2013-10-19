require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }
  it { should validate_uniqueness_of(:url) }

  it { should validate_presence_of(:url) }
  it { should have_many(:users)}


end