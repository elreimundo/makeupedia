require 'spec_helper'

describe PageUser do
  before :all do
    DatabaseCleaner.clean
  end
  it { should have_many(:changes)}
  it { should belong_to(:user)}
  it { should belong_to(:page)}

  it "should delete all associated changes on destroy" do
    user_id = rand(100)
    page_id = rand(100)
    page_user = PageUser.create(:user_id => user_id, :page_id => page_id)
    first_change = page_user.changes.create(:find_text => "Jim", :replace_text => "Smith")
    expect(first_change).to be_persisted
    page_user.destroy
    expect(first_change).not_to be_persisted
  end

  it "should uniquely link one user and one page" do
    user_id = rand(100)
    page_id = rand(100)
    page_user = PageUser.create(:user_id =>user_id, :page_id => page_id)
    expect( page_user ).to be_persisted
    page_user2 = PageUser.create(:user_id =>user_id, :page_id => page_id)
    expect( page_user2 ).not_to be_persisted
  end
  context ".permalink" do
    it "should display the proper permalink" do
      user_id = rand(100)
      new_page = Page.create(:ending => 'Internet')
      page_user = PageUser.create(:user_id => user_id, :page_id => new_page.id)
      expect( page_user.permalink ).to include("Internet")
    end

    it "should display the proper permalink for a multi-word ending" do
      user_id = rand(100)
      new_page = Page.create(:ending => 'Al Gore')
      page_user = PageUser.create( :user_id => user_id, :page_id => new_page.id)
      expect( page_user.permalink ).to include('Al_Gore')
    end

    it "should display the proper permalink including user_id" do
      user_id = rand(100)
      new_page = Page.create(:ending => 'Al Gore')
      page_user = PageUser.create( :user_id => user_id, :page_id => new_page.id)
      expect( page_user.permalink ).to eq("http://makeupedia.herokuapp.com/wiki/Al_Gore?user_id=#{user_id}")
    end
  end

  context ".find_or_create_by" do
    it "should find a page_user that already exists" do
      user_id = rand(100)
      page_id = rand(100)
      page_user = PageUser.create( :user_id => user_id, :page_id => page_id )
      expect(PageUser.find_or_create_by(:user_id => user_id, :page_id => page_id)).to eq(page_user)
    end

    it "should not create a new page_user if one already exists" do
      user_id = rand(100)
      page_id = rand(100)
      page_user = PageUser.create( :user_id => user_id, :page_id => page_id )
      expect{ PageUser.find_or_create_by(:user_id => user_id, :page_id => page_id) }.not_to change { PageUser.count }
    end

    it "should create a new page_user if one does not exist" do
      user_id = rand(100)
      page_id = rand(100)
      expect{ PageUser.find_or_create_by(:user_id => user_id, :page_id => page_id) }.to change { PageUser.count }.by(1)
      page_user = PageUser.where(:user_id => user_id).where(:page_id => page_id).first
      expect(PageUser.find_or_create_by(:user_id => user_id, :page_id => page_id)).to eq(page_user)
    end
  end
end
