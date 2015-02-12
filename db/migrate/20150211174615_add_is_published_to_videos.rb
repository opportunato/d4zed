class AddIsPublishedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :is_published, :boolean, default: false
  end
end
