class MainController < ApplicationController
  skip_before_filter :require_login

  def index
    @brands = Brand.published
    @news   = News.published
  end
end
