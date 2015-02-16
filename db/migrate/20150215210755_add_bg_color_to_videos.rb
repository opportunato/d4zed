class AddBgColorToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :bg_color, :string, default: "af4e7b"
  end
end
