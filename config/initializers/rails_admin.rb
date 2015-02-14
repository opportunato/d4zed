RailsAdmin.config do |config|
  config.main_app_name = ['d4zed', 'Admin']

  config.included_models = [Tag, News, Video]
end
