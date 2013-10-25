require 'spec_helper'

describe ChangesController do
  context "destroy" do
    it "should destroy the change" do
      expect {
        @change = Change.create( :find_text => Faker::Lorem.words( rand(5)+1 ).join(' '), :replace_text => Faker::Lorem.words( rand(5)+1 ).join(' ') )
      }.to change{ Change.count }.by(1)
      expect {
        post :destroy, :id => @change.id
      }.to change{ Change.count }.by(-1)
    end
  end
end
