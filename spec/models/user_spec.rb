require 'spec_helper'

describe User do
  before :all do
    User.destroy_all
    Page.destroy_all
    PageUser.destroy_all
    password = Faker::Lorem.words(1)
    @user = User.create(:email => Faker::Internet.email, :password => password, :password_confirmation => password)
  end

  it "should validate uniqueness of email" do
    password = Faker::Lorem.words(1)
    new_user = User.create(:email => @user.email, :password => password, :password_confirmation => password)
    expect(new_user).not_to be_persisted
  end

  it "should validate presence of email" do
    password = Faker::Lorem.words(1)
    new_user = User.create(:password => password, :password_confirmation => password)
    expect(new_user).not_to be_persisted
  end

  it { should have_many(:pages)}
  it { should have_many(:changes)}

  context "changes_for_page" do
    it "should return an empty array if the page doesn't exist" do
      expect(@user.changes_for_page("Rspec")).to be_empty
    end

    it "should return an empty object if the page exists but has no changes for user" do
      page = Page.create(:ending => "Rspec")
      expect(@user.changes_for_page("Rspec")).to be_empty
    end

    it "should return a non-empty object if the page has changes for user" do
      page = Page.find_or_create_by(:ending => "Rspec")
      page_user = PageUser.find_or_create_by(:user_id => @user.id, :page_id => page.id)
      page_user.changes.create(:find_text => "Rspec", :replace_text => "Is testing necessary?")
      expect(@user.changes_for_page("Rspec")).not_to be_empty
    end
  end
end