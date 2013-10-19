class Page < ActiveRecord::Base
  attr_accessible :url
  has_many :page_users
  has_many :users, through: :page_users
  validates :url, presence: true, uniqueness: true
end
