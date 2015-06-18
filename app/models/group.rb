class Group < ActiveRecord::Base
  has_many :users, foreign_key: 'group_id'
end