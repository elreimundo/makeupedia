require 'spec_helper'
describe "routing to makeupedia" do
  it "routes /wikis#index to root" do
    expect(:get => "/").to route_to(:controller => "wikis", :action => "index")
  end

  it "routes wikis create to wikis#create" do
    expect(:post => "/wikis").to route_to(:controller => "wikis", :action => "create")
  end
end