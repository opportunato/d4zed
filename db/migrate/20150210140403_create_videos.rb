class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :brand
      t.string :director
      t.string :music
      t.string :vimeo_id
      t.text :description
    end
  end
end
