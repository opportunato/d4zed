class MainController < ApplicationController
  def index
    @videos = Video.published
    @news   = News.published
  end
end
