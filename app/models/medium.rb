class Medium < ActiveRecord::Base
  include Taggable

  mount_uploader :thumbnail, ThumbnailUploader

  belongs_to :brand
end