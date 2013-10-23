require 'spec_helper'

describe "the signin process", :type => :feature do
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
    visit '/'
    within(".main-form") do
      fill_in 'ending', :with => 'Internet'
      fill_in 'search', :with => 'the'
      fill_in 'replace', :with => 'stuff'
    end
    expect {
      click_button 'Submit'
    }.to change { Page.count }.by 1
  end

  it "allows signed-in user to save change" do
    visit '/sessions/new'
    within(".main-form") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_button 'Log In'
    visit '/'
    within(".main-form") do
      fill_in 'ending', :with => 'Internet'
      fill_in 'search', :with => 'the'
      fill_in 'replace', :with => 'stuff'
    end
    expect {
      click_button 'Submit'
    }.to change { Change.count }.by 1
  end

end