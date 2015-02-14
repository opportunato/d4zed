class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :videos, through: :taggings, source: :taggable, source_type: 'Video'

  validates :name, presence: true, uniqueness: true
end
