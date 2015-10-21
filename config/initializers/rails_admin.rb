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

  config.included_models = [Tag, News, Brand, Medium, Page, Credit]

  config.model 'Medium' do 
    edit do 
      field :name
      field :brand
      field :description, :ck_editor
      field :vimeo_id
      field :link
      field :thumbnail
      field :is_published
      field :credits
    end

    list do
      field :name
      field :brand
      field :is_published
    end
  end

  config.model 'Credit' do
    edit do 
      field :position
      field :person
      field :order_number
    end
  end

  config.model 'Brand' do
    edit do
      field :brand
      field :bg_color
      field :size, :enum
      field :tags
      field :order_number
      field :is_published
    end

    list do
      sort_by :order_number
      field :brand
      field :is_published
      field :order_number do
        sort_reverse true
      end
    end
  end

  config.model 'Page' do
    edit do
      field :category, :enum
      field :text, :ck_editor
    end
  end

  config.model 'News' do
    edit do
      field :picture
      field :content, :ck_editor
      field :created_at
      field :is_published
    end
  end
end
