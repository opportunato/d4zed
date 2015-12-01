class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :brands, through: :taggings, source: :taggable, source_type: 'Brand'
  has_many :media, through: :taggings, source: :taggable, source_type: 'Medium'

  validates :name, presence: true, uniqueness: true

  enum kind: [ :project, :credit ]
end
