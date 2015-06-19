class User < ActiveRecord::Base
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :achievements
  has_many :repos

  validates :username, uniqueness: true
end