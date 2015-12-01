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

  def brand_categories(brand)
    brand.tags.map(&:name).join(' ')
  end

  def medium_credits(medium)
    medium.tags.map(&:name).join(' & ')
  end

  def position_name(position, credits)
    credits.length > 1 && !position.singular ? position.name.pluralize : position.name
  end

  def medium_subtitle(medium)
    [medium_credits(medium), brand_categories(medium.brand)].select{|x| x.length > 0}.join(" - ")
  end

  def medium_title(medium)
    [medium.brand.name, medium.name].select{|x| x.length > 0}.join(" - ")
  end
end
