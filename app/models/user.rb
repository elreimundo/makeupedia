class User < ActiveRecord::Base
  attr_accessible :email
  has_many :page_users
  has_many :pages, through: :page_users
  validates :email, presence: true, uniqueness: true
end
