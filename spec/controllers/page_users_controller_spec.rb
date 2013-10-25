require 'spec_helper'

describe PageUsersController do
  context "destroy" do
    it "should destroy the page_user" do
      expect {
        @page_user = PageUser.create( :user_id => rand(100), :page_id => rand(100) )
      }.to change{ PageUser.count }.by(1)
      expect {
        post :destroy, :id => @page_user.id
      }.to change{ PageUser.count }.by(-1)
    end
  end
end
