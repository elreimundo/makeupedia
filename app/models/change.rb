class Change < ActiveRecord::Base
  attr_accessible :find_text, :replace_text
  belongs_to :page_user
  validates :find_text, presence: true
  validates :replace_text, presence: true

end
