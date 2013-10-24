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
    return [] unless page = Page.find_by(:ending => ending)
    page_user = PageUser.find_or_create_by(:user_id => self.id, :page_id => page.id)
    page_user.changes
  end
end
