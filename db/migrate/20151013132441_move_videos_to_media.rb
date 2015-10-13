class MoveVideosToMedia < ActiveRecord::Migration
  def change
    Brand.transaction do
      Tagging.all.update_all("taggable_type = 'Brand'")

      Brand.all.each do |brand|
        medium = Medium.new(
          name:         brand.name,
          director:     brand.director,
          music:        brand.music,
          vimeo_id:     brand.vimeo_id,
          link:         brand.link,
          description:  brand.description,
          is_published: brand.is_published
        )
        medium.thumbnail = File.new(File.join(Rails.root, '/public' + brand.thumbnail.url))
        medium.save!
        medium.thumbnail.recreate_versions!
        brand.media << medium
        brand.name = brand.brand
        brand.save!
        Tagging.where(taggable_id: brand.id).update_all("taggable_type = 'Medium', taggable_id = #{medium.id}")
        brand.tags
      end
    end
  end
end
