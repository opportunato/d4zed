module ApplicationHelper
  def format_date(date)
    date.strftime("%d.%m.%Y")
  end

  def video_class(video)
    class_name = video.size

    if video.interactive?
      class_name += " interactive"
    end

    class_name
  end

  def video_url(video)
    video.thumbnail_url
  end
end
