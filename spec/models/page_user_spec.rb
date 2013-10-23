require 'spec_helper'

describe PageUser do
  before :all do
    PageUser.destroy_all
    Change.destroy_all
  end
  it { should have_many(:changes)}
  it { should belong_to(:user)}
  it { should belong_to(:page)}

  it "should delete all associated changes on destroy" do
    page_user = PageUser.create(:user_id => 174, :page_id => 381)
    first_change = page_user.changes.create(:find_text => "Jim", :replace_text => "Smith")
    expect(first_change).to be_persisted
    second_change = page_user.changes.create(:find_text => "Orange", :replace_text => "Object_Oriented Design")
    page_user.destroy
    expect(first_change).not_to be_persisted
  end
end
