class PictureUploader < BaseUploader
  version :small do
    process resize_to_limit: [175, 175]
    process convert: 'jpg'
  end

  version :large do
    process resize_to_limit: [315, 315]
    process convert: 'jpg'
  end
end
