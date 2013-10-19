require 'spec_helper'
describe "routing to profiles" do
  it "routes /wikis#index to root" do
    expect(:get => "/").to route_to(
      :root
    )
  end

end