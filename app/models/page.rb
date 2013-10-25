class Page < ActiveRecord::Base
  attr_accessible :ending, :cached
  has_many :page_users
  has_many :changes, through: :page_users
  has_many :users, through: :page_users
  validates :ending, presence: true, uniqueness: true

  def url
    "http://en.wikipedia.org/wiki/" + ending.split(' ').join('_')
  end

  def recently_cached?
    cached && Time.now - 1.week < updated_at
  end

  def self.find_by(query)
    page = where(query)
    page.empty? ? nil : page.first
  end

  def self.find_or_create_by(query)
    page = where(query)
    page.empty? ? create(query) : page.first
  end
end
