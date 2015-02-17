class MainController < ApplicationController
  skip_before_filter :require_login

  def index
    @videos = Video.published
    @news   = News.published
  end
end
