require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_secure_password
  attr_accessible :email, :password, :password_confirmation
  has_many :page_users
  has_many :pages, through: :page_users
  has_many :changes, through: :pages
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, on: :create

  def password
    BCrypt::Password.new(password_digest)
  end

  def changes_for_page(ending)
    changes.where(ending: ending)
    # page = pages.where(:ending => ending)
    # page.empty? ? [] : page.first.changes
  end



  #   # page = Page.where('ending=?',ending.split('_').join(' '))
  #   # page = (page.empty? ? nil : page.first)
  #   # user = User.find(user_id.to_i) if user_id
  #   # user = current_user unless user
  #   # if page && user
  #   #   page_user = PageUser.where('page_id=?', page.id).where('user_id=?',user.id)
  #   #   unless page_user.empty?
  #   #     page_user = page_user.first
  #   #     page_user.changes
  # end
end
