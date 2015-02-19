class Video < ActiveRecord::Base
  include Taggable

  before_save :set_order_number

  enum size: [ :small, :big ]

  mount_uploader :thumbnail, ThumbnailUploader

  scope :published, -> { where(is_published: true).order('order_number DESC, created_at DESC') }

  validates_presence_of :name, :music, :vimeo_id, :thumbnail, :size

  def interactive?
    link.present?
  end

  def set_order_number
    if self.order_number.blank?
      self.order_number = Video.all.order('order_number DESC').first.order_number
    end
  end
end
