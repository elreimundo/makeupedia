class Change < ActiveRecord::Base
  attr_accessible :find_text, :replace_text, :page_user_id, :ending
  belongs_to :page_user
  has_many :pages, through: :page_user
  validates :find_text, presence: true
  validates :replace_text, presence: true
  validates_uniqueness_of :find_text, scope: :page_user_id
end
