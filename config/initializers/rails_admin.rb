module ActiveRecord
  module RailsAdminEnum
    def enum(definitions)
      super
 
      definitions.each do |name, values|
        define_method("#{ name }_enum") { self.class.send(name.to_s.pluralize).to_a }
 
        define_method("#{ name }=") do |value|
          if value.kind_of?(String) and value.to_i.to_s == value
            super value.to_i
          else
            super value
          end
        end
      end
    end
  end
end
 
ActiveRecord::Base.send(:extend, ActiveRecord::RailsAdminEnum)

RailsAdmin.config do |config|
  config.authenticate_with do
    require_login
  end

  config.main_app_name = ['d4zed', 'Admin']

  config.included_models = [Tag, News, Video]

  config.model 'Video' do
    edit do
      field :name
      field :brand
      field :director
      field :music
      field :description, :wysihtml5 do
        config_options parserRules: { tags: { p:1 } }, toolbar: { fa: true }
      end
      field :vimeo_id
      field :bg_color
      field :size, :enum
      field :thumbnail
      field :tags
      field :created_at
      field :is_published
    end
  end

  config.model 'News' do
    edit do
      field :picture
      field :content, :wysihtml5 do
        config_options parserRules: { tags: { p:1 } }, toolbar: { fa: true }
      end
      field :is_published
    end
  end
end
