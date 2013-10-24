require 'spec_helper'
#include AuthHelper

describe WikisController do
  #let! (:page) { FactoryGirl.create(:page) } ## Fails because not a real url
  #let! (:change) { FactoryGirl.create(:change) } ## Fails because conflicts with change method, below


  describe "POST #create" do
    it "should not create a new page for an anonymous user" do
      expect {
        post :create, :ending => "Internet", :search => "hi", :replace => "bye"
      }.not_to change { Page.count }
    end

    it "should not create a new change for an anonymous user" do
      expect {
        post :create, :ending => "Internet", :search => "hi", :replace => "bye"
      }.not_to change { Change.count }
    end
  end
end