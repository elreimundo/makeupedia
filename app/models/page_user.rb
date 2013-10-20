class PageUser < ActiveRecord::Base
	attr_accessible :user_id, :page_id
  belongs_to :user
  belongs_to :page
  has_many :changes
  validates_uniqueness_of :page_id, :scope => :user_id
end
