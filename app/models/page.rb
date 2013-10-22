class Page < ActiveRecord::Base
  attr_accessible :ending
  has_many :page_users
  has_many :users, through: :page_users
  validates :ending, presence: true, uniqueness: true

  def url
    "http://en.wikipedia.org/wiki/" + self.ending.split(' ').join('_')
  end
end
