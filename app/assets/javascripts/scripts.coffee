gutterSize = 35
$main      = $('#main > .wrapper')
$videos    = $('#work > .wrapper')
$work      = $('#work')
$header    = $('body > header > .header-wrapper > .wrapper')
$sections  = $('#about, #news')
$news      = $('#news article')
$about     = $('#about')
$newsBlock = $('#news')
$social    = $('footer .social')

videos = {
  left: []
  right: []
}

smallMobileBreakpoint = 500
mobileBreakpoint      = 804
smallTabletBreakpoint = 930
tabletBreakpoint      = 1024
largeBreakbpoint      = 1507
maxWidth              = 1367

calculateAboutHeight = ->
  if $(window).width() < tabletBreakpoint
    height = $about.find('p').height()
    newHeight = Math.ceil(height/gutterSize) * gutterSize + 2 * gutterSize - 2
  else
    newHeight = 5 * gutterSize - 2

  $about.height(newHeight)
  $about.data('height', newHeight)

scrollToBlock = (id) ->
  $('body').removeClass('menu-opened')

  aTag = $("#{id}")
  windowWidth   = $(window).width()
  headerOffset = if windowWidth > mobileBreakpoint then 5 * 35 else 4 * 35

  $('html,body').animate({ scrollTop: aTag.offset().top - headerOffset }, 'slow')


scrollToTop = (event) ->
  event.preventDefault()
  $('html,body').animate({ scrollTop: 0 }, 'slow')


calculateMainWidth = ->
  $('body').addClass('no-transition')

  videos = {
    left: []
    right: []
  }
  windowWidth   = $(window).width()

  if windowWidth > largeBreakbpoint
    newWidth = maxWidth
    marginLeft = Math.ceil(Math.floor((windowWidth - newWidth)/gutterSize) / 2) * gutterSize - 2
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

  if windowWidth < smallTabletBreakpoint
    socialMargin = Math.ceil(Math.floor((newWidth - $social.width())/gutterSize) / 2) * gutterSize + 1
    $social.css('margin-left', "#{socialMargin}px")
  else
    $social.css('margin-left', 'auto')

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
    $video.find('iframe').css(height: height)
    $video.find('article').css(width: width)

  if windowWidth > tabletBreakpoint
    newsWidth = (newWidth - gutterSize)/2 + 1
  else
    newsWidth = newWidth

  $news.add($sections).css(width: newsWidth)
  updateNews()
  $videos.each (index, video) ->
    updateVideo($(video))

  calculateAboutHeight()

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
    $videos.css(
      position: 'relative'
      left: 0
      top: 0
    )
    $('#work').height('auto')

  setTimeout ->
    $('body').removeClass('no-transition')
  , 250

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
    $about.height($about.data('height'))


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
$newsWrapper   = $('#news .wrapper')

updateArrows = ($wrapper) ->
  $container = $wrapper.find(".container")
  width = $container.children().width()
  currentIndex = $wrapper.data('index') || 0

  $container.css('transform', "translate(#{-currentIndex * width}px)")

  $prev = $wrapper.find(".prev")
  $next = $wrapper.find(".next")

  $prev = $wrapper.closest("#news").find(".prev") if ($prev.length == 0)
  $next = $wrapper.closest("#news").find(".next") if ($next.length == 0)

  if currentIndex == 0
    $prev.addClass('inactive');
    $next.removeClass('inactive');
  else if currentIndex == $wrapper.find('.container').children().length - 1
    $prev.removeClass('inactive');
    $next.addClass('inactive');
  else
    $prev.add($next).removeClass('inactive');

updateVideo = ($videoContainer) ->
  updateArrows($videoContainer)

updateNews = ->
  $container = $newsWrapper.find(".container")
  $block = $($container.children().get($newsWrapper.data('index')))
  $('#news .date').text($block.data('date'))

  updateArrows($newsWrapper);

navigate = ($wrapper, direction) ->
  $container = $wrapper.find(".container")
  currentIndex = $wrapper.data('index') || 0;
  blocksNumber = $container.children().length

  if direction == 'prev'
    return if currentIndex == 0

    currentIndex -= 1
  else if direction == 'next'
    return if currentIndex == blocksNumber - 1

    currentIndex += 1
  else
    return

  $wrapper.data('index', currentIndex)

initiateInfiniteScroll = ->
  $invisibleVideos = $videos.slice(5)
  $invisibleVideos.remove()
  $videos = $('#work > .wrapper')

  $(document).on 'scroll', ->
    return if ($invisibleVideos.length == 0)

    if $(document).scrollTop() > $work.offset().top + $work.height() - $(window).height()
      $work.append($invisibleVideos.slice(0, 5))
      $invisibleVideos = $invisibleVideos.slice(5)
      $videos = $('#work > .wrapper')
      calculateMainWidth()
      initializeVideoSliders()
      initializePlayer()

prevSlide = ->
  $videoContainer = $(this.closest(".wrapper"))
  navigate($videoContainer, 'prev')
  updateVideo($videoContainer)

nextSlide = ->
  $videoContainer = $(this.closest(".wrapper"))
  navigate($videoContainer, 'next')
  updateVideo($videoContainer)


initializeVideoSliders = ->
  $('#work .prev').off 'click', prevSlide
  $('#work .prev').on 'click', prevSlide
  $('#work .next').off 'click', nextSlide
  $('#work .next').on 'click', nextSlide
  $videos.each (index, video) ->
    updateVideo($(video))


playVideo = (e) ->
  $container = $(e.target).parents('article')

  $videos.each (index, video) ->
    $video = $(video)
    $video.removeClass('playing loading')

    if player = $video.find('iframe')[0]
      $f(player).api("pause")

  $container.addClass('loading')

  if $container.children('iframe').length == 0
    $container.find('.gradient').after("<iframe src='https://player.vimeo.com/video/" + $container.data("vimeoId") + "?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff' width='560' height='315' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>");
    videoHeight = $container.height()
    if $container.hasClass('expanded')
      videoHeight = videoHeight - 175
    $container.find('iframe').css(height: videoHeight)
    
    player = $f($container.children('iframe')[0])

    player.addEvent "ready", ->
      $container.removeClass('loading').addClass('playing')

      player.api("play")

      player.addEvent "pause", ->
        $container.removeClass('playing')

      player.addEvent "finish", ->
        $container.removeClass('playing')
  else
    $videos.removeClass('playing loading')
    $container.addClass('playing').removeClass('loading')
    
    player = $f($container.children('iframe')[0])
    player.api("play")


initializePlayer = ->
  $('.player, .mobile-player').off 'click', playVideo
  $('.player, .mobile-player').on 'click', playVideo


$ ->
  initiateInfiniteScroll()

  $('body').css('visibility', 'visible')

  calculateMainWidth()

  $(window).on 'resize orientationchange', ->
    $videos.each (index, video) ->
      if $(video).hasClass('expanded')
        expandVideo($(video))

    if $about.hasClass('expanded')
      expandAbout()

    calculateMainWidth()

  setTimeout ->
    $('body').removeClass('no-transition')
  , 300

  player = null

  $('#about .expander').on 'click', ->
    expandAbout()

  $('#work .expander').on 'click', ->
    expandVideo($(@).closest('article'))

  $('#news .prev').on 'click', ->
    navigate($newsWrapper, 'prev')
    updateNews()

  $('#news .next').on 'click', ->
    navigate($newsWrapper, 'next')
    updateNews()

  $('.mobile-menu-button').on 'click', ->
    $('body').toggleClass('menu-opened')

  $('.menu a').on 'click', (event) ->
    event.preventDefault()
    id = $(this).attr('href')

    scrollToBlock(id)

  $('.root-link').on 'click', scrollToTop

  if location.hash != ''
    scrollToBlock(location.hash)

  updateNews()
  initializeVideoSliders()
  initializePlayer()

  
    
