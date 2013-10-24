class PageUser < ActiveRecord::Base
	attr_accessible :user_id, :page_id
  belongs_to :user
  belongs_to :page
  has_many :changes, dependent: :destroy
  validates_uniqueness_of :page_id, :scope => :user_id

  def permalink
    "http://makeupedia.herokuapp.com/wiki/" + page.ending.split(' ').join('_') + "?user_id=" + user_id.to_s
  end

  def self.find_or_create_by(hash)
    page_user = PageUser.where(:user_id => hash[:user_id]).where(:page_id => hash[:page_id])
    page_user.empty? ? PageUser.create(:user_id => hash[:user_id], :page_id => hash[:page_id]) : page_user.first
  end
end
