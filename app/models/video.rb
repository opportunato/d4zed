class Video < ActiveRecord::Base
  mount_uploader :thumbnail, ThumbnailUploader
end
