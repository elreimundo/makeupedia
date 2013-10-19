require 'spec_helper'

describe PageUser do
  it { should have_many(:changes)}
  it { should belong_to(:user)}
  it { should belong_to(:page)}

end
