module ApplicationHelper
  def video_group(videos)
    videos.each_with_index.reduce({first: [], second: []}) do |memo, (video, index)|
      if index == 0
        memo[:main] = video
      elsif index % 2 == 1
        memo[:first].push(video)
      else
        memo[:second].push(video)
      end

      memo
    end
  end
end
