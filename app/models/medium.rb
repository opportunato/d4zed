class Medium < ActiveRecord::Base
  mount_uploader :thumbnail, ThumbnailUploader

  belongs_to :brand
end