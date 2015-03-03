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
    # if video.interactive?
    #   video.thumbnail_url(:square)
    # elsif video.big?
    #   video.thumbnail_url(:main)
    # else
    #   video.thumbnail_url(:large)
    # end
    video.thumbnail_url
  end

  def video_categories(video)
    if video.tags.length > 0
      "(#{video.tags.map(&:name).join(' ')})"
    else
      ""
    end
  end
end
