require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }
  it { should validate_uniqueness_of(:ending) }

  it { should validate_presence_of(:ending) }
  it { should have_many(:users) }
  it { should have_many(:changes) }
  it { should have_many(:page_users) }

  it "should render the proper url when .url is called" do
    ending = Faker::Lorem.words(rand(5)+1).join(" ")
    page = Page.create(:ending => ending)
    expect(page.url).to eq("http://en.wikipedia.org/wiki/#{ending.split(' ').join('_')}")
  end

  context ".find_by" do
    it "should find an existing page given a queried ending" do
      ending = Faker::Lorem.words(rand(5)+1).join(" ")
      page = Page.create(:ending => ending)
      expect(Page.find_by(:ending => ending)).to eq(page)
    end

    it "should return nil if no such page exists" do
      expect( Page.find_by( :ending => Faker::Lorem.words( rand(5)+1 ).join(" ") ) ).to be(nil)
    end
  end

  context ".find_or_create_by" do
    it "should find - and not create - an existing page given a queried entry" do
      ending = Faker::Lorem.words(rand(5)+1).join(" ")
      page = Page.create(:ending => ending)
      expect{ @find_by_page = Page.find_by(:ending => ending) }.not_to change{ Page.count }
      expect(@find_by_page).to eq(page)
    end

    it "should create a page based on a query if no such page exists" do
      ending = Faker::Lorem.words(rand(5)+1).join(" ")
      expect{ Page.find_or_create_by(:ending => ending) }.to change{ Page.count }.by(1)
    end
  end
end