require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  has_secure_password
  attr_accessible :email, :password, :password_confirmation
  has_many :page_users
  has_many :pages, through: :page_users
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, on: :create

  def password
    BCrypt::Password.new(password_digest)
  end
end
