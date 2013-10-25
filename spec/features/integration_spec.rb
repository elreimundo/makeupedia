require 'spec_helper'

describe "the signin process", :type => :feature do
  before :all do
    DatabaseCleaner.clean
  end

  before :each do
    User.create(:email => 'user@example.com', :password => 'caplin')
  end

  it "signs me in" do
    visit '/sessions/new'
    within(".main-form") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Log In'
    expect(page).to have_content 'user@example.com'
  end

  it "allows signed-in user to save page" do
    visit '/sessions/new'
    within(".main-form") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Log In'
    expect {
      visit '/wiki/Internet'
    }.to change { Page.count }.by 1
  end

  it "allows signed-in user to save change" do
    visit '/sessions/new'
    within(".main-form") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Log In'
    visit '/wiki/Internet'
    within(".second-form") do
      fill_in 'search', :with => 'Internet'
      fill_in 'replace', :with => 'Al Gore'
    end
    expect {
      click_button 'Submit'
    }.to change { Change.count }.by 1
  end

end