# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\-\+_]/u

  storage :file

  after :remove, :delete_empty_upstream_dirs

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{id_partition(model.id)}/#{mounted_as}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      "#{secure_token(10)}.#{file.extension}"
    elsif model && model.read_attribute(:mounted_at).present?
      model.read_attribute(:mounted_at)
    end
  end

private

  def id_partition id
    case id
    when Integer
      ("%09d" % id).scan(/\d{3}/).join("/")
    when String
      id.scan(/.{3}/).first(3).join("/")
    else
      nil
    end
  end

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path)
    rescue SystemCallError
      true
  end

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
