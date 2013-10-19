require 'spec_helper'

describe WikisController do
  #let! (:page) { FactoryGirl.create(:page) } ## Fails because not a real url
  #let! (:change) { FactoryGirl.create(:change) } ## Fails because conflicts with change method, below

  # before(:each) do
  #   @page = { :url => "http://www.cnn.com" }
  # end

  describe "POST #create" do
    it "should create a new page" do
      expect {
        post :create, :url => "http://www.cnn.com", :search => "hi", :replace => "bye"
      }.to change { Page.count }.by 1
    end

    it "should create a new change" do
      expect {
        post :create, :url => "http://www.cnn.com", :search => "hi", :replace => "bye"
      }.to change { Change.count }.by 1
    end
  end

end