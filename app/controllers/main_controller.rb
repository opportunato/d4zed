class MainController < ApplicationController
  def index
    @videos = Video.published
  end
end
