class Change < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :page_user
end
