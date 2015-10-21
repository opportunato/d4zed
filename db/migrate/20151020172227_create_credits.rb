class CreateCredits < ActiveRecord::Migration
  def change
    Credit.transaction do
      create_table :credits do |t|
        t.string     :person
        t.references :position
        t.references :medium

        t.timestamps
      end

      create_table :positions do |t|
        t.string :name
        t.boolean :singular, default: false

        t.timestamps
      end

      director_pos = Position.create(name: "Director")
      music_pos = Position.create(name: "Composer")
      Position.create(name: "Production", singular: true)
      Position.create(name: "Agency", singular: true)
      Position.create(name: "Editor")
      Position.create(name: "Sound designer")

      Medium.all.each do |medium|
        medium.credits << Credit.create(person: medium.director, position: director_pos) if medium.director.present?
        medium.credits << Credit.create(person: medium.music, position: music_pos) if medium.music.present?
        medium.save!
      end
    end
  end
end
