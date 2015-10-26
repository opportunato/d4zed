class MainController < ApplicationController
  skip_before_filter :require_login

  def index
    @brands = Brand.published.select { |brand| brand.media.length > 0 }
    @news   = News.published
  end
end
