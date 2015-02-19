class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :text
      t.integer :category, default: 0

      t.timestamps
    end
  end
end
