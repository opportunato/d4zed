module ApplicationHelper
  def video_class(index)
    if index == 0
      "main"
    elsif index % 4 == 1 || index % 4 == 0
      "big"
    else
      "small"
    end
  end
end
