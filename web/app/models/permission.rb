class Permission < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
end
