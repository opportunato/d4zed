class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.text     :content
      t.string   :picture
      t.boolean  :is_published

      t.timestamps
    end
  end
end
