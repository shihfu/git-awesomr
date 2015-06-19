class User < ActiveRecord::Base
  belongs_to :group
  validates :username, uniqueness: true
end