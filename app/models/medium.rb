class Medium < ActiveRecord::Base
  mount_uploader :thumbnail, ThumbnailUploader

  belongs_to :brand
  has_many :credits, dependent: :destroy

  accepts_nested_attributes_for :credits, allow_destroy: true
end