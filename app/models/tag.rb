class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :brands, through: :taggings, source: :taggable, source_type: 'Brand'

  validates :name, presence: true, uniqueness: true
end
