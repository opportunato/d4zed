class Video < ActiveRecord::Base
  include Taggable

  mount_uploader :thumbnail, ThumbnailUploader

  scope :published, -> { where(is_published: true) }

  validates_presence_of :name, :director, :music, :vimeo_id, :thumbnail
end
