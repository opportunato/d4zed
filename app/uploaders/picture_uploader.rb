class PictureUploader < BaseUploader
  version :large do
    process resize_to_limit: [315, 315]
    process convert: 'jpg'
  end
end
