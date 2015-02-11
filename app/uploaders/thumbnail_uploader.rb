class ThumbnailUploader < BaseUploader
  version :small do
    process resize_to_limit: [280, 0]
    process convert: 'jpg'
  end

  version :large do
    process resize_to_limit: [600, 0]
    process convert: 'jpg'
  end

  version :square do
    process resize_to_fill: [600, 600]
    process convert: 'jpg' 
  end

  version :main do
    process resize_to_limit: [1250, 0]
    process convert: 'jpg'
  end
end
