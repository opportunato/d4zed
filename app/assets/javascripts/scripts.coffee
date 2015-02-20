gutterSize = 35
$main      = $('#main > .wrapper')
$videos    = $('#work > article')
$header    = $('body > header > .wrapper')
$sections  = $('#about, #news')
$news      = $('#news article')

videos = {
  left: []
  right: []
}

mobileBreakpoint = 804
tabletBreakpoint = 1024
largeBreakbpoint = 1507
maxWidth         = 1367

scrollToBlock = (event) ->
  event.preventDefault()
  id = $(this).attr('href')

  $('body').removeClass('menu-opened')

  aTag = $("#{id}")
  windowWidth   = $(window).width()
  headerOffset = if windowWidth > mobileBreakpoint then 5 * 35 else 4 * 35

  $('html,body').animate({ scrollTop: aTag.offset().top - headerOffset }, 'slow')

scrollToTop = (event) ->
  event.preventDefault()
  $('html,body').animate({ scrollTop: 0 }, 'slow')


calculateMainWidth = ->
  videos = {
    left: []
    right: []
  }
  windowWidth   = $(window).width()

  if windowWidth > largeBreakbpoint
    newWidth = maxWidth
    marginLeft = Math.floor(Math.floor((windowWidth - newWidth)/gutterSize) * gutterSize / 2)
  else 
    if windowWidth > mobileBreakpoint
      marginSize = 4
    else
      marginSize = 2

    blockWidth    = windowWidth - marginSize * gutterSize

    gutterNumber  = Math.floor(blockWidth / gutterSize)

    if windowWidth > mobileBreakpoint 
      marginNumber = 2

      if gutterNumber % 2 == 0
        gutterNumber -= 1
        marginNumber = 3
    else
      marginNumber = 1

    newWidth = gutterNumber * gutterSize + 2
    marginLeft = marginNumber * gutterSize - 2

  $main.add($header).css(
    'margin-left': marginLeft
    'width': newWidth
  )

  if windowWidth > mobileBreakpoint
    smallWidth  = ((newWidth - gutterSize)/2 + 1)
  else
    smallWidth = newWidth

  smallHeight = Math.floor(smallWidth/(2 * gutterSize)) * gutterSize + 2
  squareHeight = 2 * smallHeight + gutterSize - 2

  $videos.each (index, video) ->
    $video = $(video)
    ratio = if $video.hasClass('interactive') then 1 else 2
    if windowWidth > mobileBreakpoint
      width = if $video.hasClass('big') then newWidth else smallWidth
    else
      width = newWidth

    height = if $video.hasClass('big')
      Math.floor(width/(ratio * gutterSize)) * gutterSize + 2
    else
      if $video.hasClass('interactive') then squareHeight else smallHeight

    $video.css(width: width, height: height)  

  if windowWidth > mobileBreakpoint
    $news.add($sections).css(width: (newWidth - gutterSize)/2 + 1)
  else
    $news.add($sections).css(width: newWidth)

  if windowWidth > mobileBreakpoint
    leftTop = 0
    rightTop = 0
    leftPosition = 0
    rightPosition = (newWidth - gutterSize)/2 + gutterSize - 1

    videoGutter = if windowWidth > tabletBreakpoint
      gutterSize - 2
    else
      2 * gutterSize - 2

    $videos.each (index, video) ->
      $video = $(video)

      if $video.hasClass('small')
        if leftTop <= rightTop
          newTop = leftTop
          newPosition = leftPosition
          leftTop += $video.height() + videoGutter
          videos.left.push $video
        else
          newTop = rightTop
          newPosition = rightPosition
          rightTop += $video.height() + videoGutter
          videos.right.push $video
      else
        newTop = Math.max(leftTop, rightTop)
        newPosition = leftPosition
        leftTop = newTop + $video.height() + videoGutter
        rightTop = newTop + $video.height() + videoGutter
        videos.left.push $video
        videos.right.push $video

      $video.css(
        position: 'absolute'
        top: newTop
        left: newPosition
      )

    $('#work').height(Math.max(leftTop, rightTop))
  else
    $videos.css('position', 'relative')

updateVideos = ($updatedVideo, additionalHeight) ->
  position = if $updatedVideo.css('left') == '0px' then 'left' else 'right'

  index = videos[position].indexOf($updatedVideo)

  laterVideos = videos[position].filter ($video) ->
    parseInt($video.css('top')) > parseInt($updatedVideo.css('top'))

  laterVideos.forEach ($video) ->
    currentTop = parseInt($video.css('top'))

    $video.css('top', currentTop + additionalHeight)

  $('#work').height($('#work').height() + additionalHeight)


expandAbout = ->
  $about = $('#about')

  $about.toggleClass('expanded')

  if $about.hasClass('expanded')
    $content = $about.find('.content')
    fullHeight = $content.height()

    newHeight = Math.ceil(fullHeight/gutterSize) * gutterSize + gutterSize - 2

    $about.height(newHeight)
  else
    $about.height(5 * gutterSize - 2)

expandVideo = ($video) ->
  $videos.not($video).each (index, video) ->
    if $(video).hasClass('expanded')
      expandVideo($(video))

  $video.toggleClass('expanded')
  $cover = $video.find('.cover')
  $bg = $video.find('.bg')
  $info = $video.find('.info')

  if $video.hasClass('expanded')
    $info.show()

    $color = $bg.css('backgroundColor')
    $cover.css(
      height: $video.height()
      position: 'relative'
    )

    $info.css(
      borderTop: 'none'
      backgroundColor: $color,
      display: 'block'
      position: 'relative'
      height: 175
      width: '100%'
    )

    additionalHeight = $info.innerHeight() + 2

    $video.css(
      height: $cover.height() + $info.innerHeight() + 6
    )
  else
    additionalHeight = ($cover.height() + 4) - $video.height()

    $info.hide()
    $video.css(
      height: $cover.height() + 4
    )

  updateVideos($video, additionalHeight)

currentNewsIndex = 0
$newsContainer   = $('#news .container')
newsNumber       = $newsContainer.children().length

updateNews = ->
  $block = $($newsContainer.children().get(currentNewsIndex))

  $('#news .date').text($block.data('date'))

  if currentNewsIndex == 0
    $('.prev').addClass('inactive');
    $('.next').removeClass('inactive');
  else if currentNewsIndex == newsNumber - 1
    $('.prev').removeClass('inactive');
    $('.next').addClass('inactive');
  else
    $('.next, .prev').removeClass('inactive');

navigateNews = (direction) ->
  newsWidth = $newsContainer.children().width()

  if direction == 'prev'
    return if currentNewsIndex == 0

    currentNewsIndex -= 1
  else if direction == 'next'
    return if currentNewsIndex == newsNumber - 1

    currentNewsIndex += 1
  else
    return

  $newsContainer.css('left', - currentNewsIndex * newsWidth)
  updateNews()

$ ->
  $('body').css('visibility', 'visible')

  calculateMainWidth()

  $(window).resize(calculateMainWidth)

  player = null

  $('#about .expander').on 'click', ->
    expandAbout()

  $('#work .expander').on 'click', ->
    expandVideo($(@).closest('article'))

  $('.prev').on 'click', ->
    navigateNews('prev')

  $('.next').on 'click', ->
    navigateNews('next')

  $('.mobile-menu-button').on 'click', ->
    $('body').toggleClass('menu-opened')

  $('.menu a').on 'click', scrollToBlock
  $('.root-link').on 'click', scrollToTop

  $('#work article').on 'touchstart', ->
    $videos.not($(this)).removeClass('touched')
    $(this).toggleClass('touched')

  updateNews()

  $('.player').on 'click', (e) ->
    $container = $(e.target).parents('article')

    $container.addClass('loading')

    if $container.children('iframe').length == 0
      $videos.removeClass('playing')
      $container.append("<iframe src='//player.vimeo.com/video/" + $container.data("vimeoId") + "?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff' width='560' height='315' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>");
  
      if player
        player.api("pause");
      
      player = $f($container.children('iframe')[0])

      player.addEvent "ready", ->
        $container.removeClass('loading').addClass('playing')

        player.api("play")
        
        player.addEvent "finish", ->
          $container.removeClass('playing')

        player.addEvent "pause", ->
          $container.removeClass('playing')
    else
      $videos.removeClass('playing loading')
      $container.addClass('playing').removeClass('loading')
      
      player = $f($container.children('iframe')[0])
      player.api("play")