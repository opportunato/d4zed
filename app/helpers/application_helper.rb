module ApplicationHelper
  def format_date(date)
    date.strftime("%d.%m.%Y")
  end

  def video_class(video)
    class_name = video.size

    if video.interactive?
      class_name += " interactive"
    end

    class_name + " wrapper"
  end

  def medium_url(medium)
    if medium.brand.interactive?
      medium.thumbnail_url(:square)
    elsif medium.brand.big?
      medium.thumbnail_url(:main)
    else
      medium.thumbnail_url(:large)
    end
  end

  def video_categories(video)
    if video.tags.length > 0
      "(#{video.tags.map(&:name).join(' ')})"
    else
      ""
    end
  end
end
