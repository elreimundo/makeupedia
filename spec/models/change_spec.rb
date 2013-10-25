require 'spec_helper'

describe Change do
  let(:change) { FactoryGirl.create(:change) }
  it { should validate_presence_of(:find_text) }
  it { should validate_presence_of(:replace_text) }

  it { should belong_to(:page_user) }
  it { should have_many(:pages) }
end
