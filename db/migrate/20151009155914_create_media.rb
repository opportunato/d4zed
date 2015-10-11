class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string  :name
      t.integer :brand_id
      t.string  :director
      t.string  :music
      t.string  :vimeo_id
      t.string  :link
      t.text    :description
      t.string  :thumbnail
      t.boolean :is_published, default: false
      t.integer :order_number, default: 0

      t.timestamps
    end
  end
end
