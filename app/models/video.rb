class Video < ActiveRecord::Base
  include Taggable

  enum size: [ :small, :big ]

  mount_uploader :thumbnail, ThumbnailUploader

  scope :published, -> { where(is_published: true).order('created_at') }

  validates_presence_of :name, :director, :music, :vimeo_id, :thumbnail, :size
end
