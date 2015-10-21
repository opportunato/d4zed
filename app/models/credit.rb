class Credit < ActiveRecord::Base
  belongs_to :medium
  belongs_to :position
end