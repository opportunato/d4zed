gutterSize = 35
$main      = $('#main > .wrapper')
$videos    = $('#work > .wrapper')
$work      = $('#work')
$header    = $('body > header > .header-wrapper > .wrapper')
$sections  = $('#about, #contacts')
$about     = $('#about')
$contacts  = $('#contacts')

videos = {
  left: []
  right: []
}

tinyMobileBreakpoint  = 420
mobileBreakpoint      = 804
tabletBreakpoint      = 1024
largeBreakbpoint      = 1507
maxWidth              = 1367

players = {}

calculateSectionsHeight = ->
  height = $about.find('.content > p, .content > div').map((index, child) => $(child).height()).toArray().reduce((memo, x) => memo + x)
  aboutHeight = Math.ceil(height/gutterSize + 0.5) * gutterSize + 2 * gutterSize - 2
  contactsHeight = Math.floor($contacts.find('.wrapper').outerHeight()/gutterSize) * gutterSize - 2
  windowWidth   = $(window).width()

  if windowWidth > tabletBreakpoint
    $sections.height(Math.max(aboutHeight, contactsHeight))
  else
    $about.height(aboutHeight)
    $contacts.height(contactsHeight)


scrollToBlock = (id) ->
  $('body').removeClass('menu-opened')

  aTag = $("#{id}")
  headerOffset = 4 * gutterSize

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
    # calculate left/right margin size
    if windowWidth > mobileBreakpoint
      marginSize = 4
    else
      marginSize = 2

    # calculate each block width
    blockWidth    = windowWidth - marginSize * gutterSize

    gutterNumber  = Math.floor(blockWidth / gutterSize)

    # calculate left margin number
    if windowWidth > mobileBreakpoint
      marginNumber = 2

      if gutterNumber % 2 == 0
        gutterNumber -= 1
        marginNumber = 3
    else
      marginNumber = 1

    newWidth = if windowWidth > tinyMobileBreakpoint then gutterNumber * gutterSize + 2 else windowWidth - 2 * gutterSize + 2
    marginLeft = marginNumber * gutterSize - 2

  $header.css(
    'margin-left': marginLeft
    'width': newWidth
  )

  if windowWidth < tinyMobileBreakpoint
    newWidth = windowWidth
    marginLeft = 0

  $main.css(
    'margin-left': marginLeft
    'width': newWidth
  )

  # calculate width for small videos
  if windowWidth > mobileBreakpoint
    smallWidth  = ((newWidth - gutterSize)/2 + 1)
  else
    smallWidth = newWidth

  smallHeight = Math.floor(smallWidth/(2 * gutterSize)) * gutterSize + 2 + 2 * gutterSize
  squareHeight = 2 * smallHeight + gutterSize - 2
  squareHeight += gutterSize if windowWidth < tabletBreakpoint

  # set video dimensions
  $videos.each (index, video) ->
    $video = $(video)
    ratio = if $video.hasClass('interactive') then 1 else 2
    if windowWidth > mobileBreakpoint
      width = if $video.hasClass('big') then newWidth else smallWidth
    else
      width = newWidth

    if windowWidth > tinyMobileBreakpoint
      height = if $video.hasClass('big')
        height = Math.floor(width/(ratio * gutterSize)) * gutterSize + 3 * gutterSize + 2;
      else
        if $video.hasClass('interactive') && windowWidth > mobileBreakpoint then squareHeight else smallHeight
    else
      height = Math.floor(newWidth / gutterSize) * gutterSize + 2

    containerHeight = if windowWidth <= tabletBreakpoint then height - gutterSize else height

    $video.css(width: width, height: height)
    $video.find('iframe').css(height: containerHeight)
    $video.find('article').css(width: width)
    $video.find('.next, .prev').css(top: (containerHeight)/2 - 50)

  if windowWidth > tabletBreakpoint
    sectionsWidth = (newWidth - gutterSize)/2 + 1
  else
    sectionsWidth = newWidth

  # set expanders for tiny screens
  $expanders = $(".expander")
  $playButtons = $("#work .mobile-player, #work .mobile-link")

  if windowWidth > tinyMobileBreakpoint
    $expanders.add($playButtons).css(right: "")
  else
    expanderRight = windowWidth % gutterSize
    $expanders.css(right: expanderRight)
    $playButtons.css(right: expanderRight + gutterSize)

  $sections.css(width: sectionsWidth)
  $videos.each (index, video) ->
    updateVideo($(video))

  calculateSectionsHeight()

  # calculate video positions
  if windowWidth > mobileBreakpoint
    leftTop = 0
    rightTop = 0
    leftPosition = 0
    rightPosition = (newWidth - gutterSize)/2 + gutterSize - 1

    # include gutter size
    videoGutter = gutterSize - 2

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
  if ($updatedVideo.hasClass('big'))
    $updatedVideos = $videos.toArray()
  else
    position = if $updatedVideo.css('left') == '0px' then 'left' else 'right'
    $updatedVideos = videos[position]

  laterVideos = $updatedVideos.filter (video) ->
    parseInt($(video).css('top')) > parseInt($updatedVideo.css('top'))

  laterVideos.forEach (video) ->
    currentTop = parseInt($(video).css('top'))

    $(video).css('top', currentTop + additionalHeight)

  $('#work').height($('#work').height() + additionalHeight)


expandVideo = ($video) ->
  $videos.not($video).each (index, video) ->
    if $(video).hasClass('expanded')
      expandVideo($(video))

  $video.toggleClass('expanded')
  $cover = $video.find('.cover')
  $bg = $video.find('.bg')
  $info = $video.children('.info.mobile')
  $infoWrapper = $info.children('.mobile-container')

  if $video.hasClass('expanded')
    $info.show()

    $color = $bg.css('backgroundColor')
    $cover.css(
      height: $video.height() - gutterSize
      position: 'relative'
    )
    $info.css(
      backgroundColor: $color,
      display: 'block'
      top: $video.height() - gutterSize
      width: '100%'
    )
    gutterLeft = $infoWrapper.height() % gutterSize
    gutterAdd = if gutterLeft > gutterSize/2 || gutterLeft == 0 then 0 else -gutterSize
    $info.css(height: Math.ceil($infoWrapper.height() / gutterSize) * gutterSize + gutterAdd + 2 * gutterSize)

    additionalHeight = $info.innerHeight() + 2

    $video.css(
      height: $cover.height() + $info.innerHeight() + 6 + gutterSize
    )
  else
    additionalHeight = ($cover.height() + 4) - $video.height() + gutterSize

    $info.hide()
    $video.css(
      height: $cover.height() + 4 + gutterSize
    )
    $cover.css(height: "", position: "absolute")

  updateVideos($video, additionalHeight)

getCurrentIndex = ($wrapper) ->
  if $wrapper.find(".media").length > 1
    ($wrapper.data("index") || 0) + 1
  else
    0

updateArrows = ($wrapper) ->
  $container = $wrapper.find(".container")
  width = $container.children().width()

  $container.css('transform', "translate(#{-getCurrentIndex($wrapper) * width}px)")


updateVideo = ($videoContainer) ->
  $infoWrapper = $videoContainer.children(".info").children('.mobile-container')
  currentIndex = $videoContainer.data("index") || 0

  $articles = $videoContainer.find('article')
  $video = $($articles.filter((index, article) ->
    $(article).data("index") == currentIndex))

  $info = $video.find('.info.mobile').children().clone()
  $infoHeader = $video.find('.info.desktop').children('header').clone()

  $infoWrapper.children().remove()
  $infoWrapper.append($infoHeader).append($info)

  $mobileLink = $videoContainer.find('button.mobile-link > a')
  if $mobileLink.length > 0
    href = $video.find('.link').attr('href')
    $mobileLink.attr('href', href)

  updateArrows($videoContainer)

navigate = ($wrapper, direction) ->
  return if ($wrapper.data("in_transition"))

  currentIndex = $wrapper.data('index') || 0;

  $wrapper.data("in_transition", true)

  if direction == 'prev'
    currentIndex -= 1
  else if direction == 'next'
    currentIndex += 1
  else
    currentIndex = direction

  $wrapper.data('index', currentIndex)

$invisibleVideos = null

initiateInfiniteScroll = ->
  $invisibleVideos = $videos.slice(5)
  $invisibleVideos.remove()
  $videos = $('#work > .wrapper')

  $(document).on 'scroll', ->
    return if ($invisibleVideos.length == 0)

    if $(document).scrollTop() > $work.offset().top + $work.height() - $(window).height() - 2000
      loadVideos($invisibleVideos.slice(0, 5))
      $invisibleVideos = $invisibleVideos.slice(5)

loadVideos = ($newVideos) ->
  $work.append($newVideos)
  $videos = $('#work > .wrapper')
  calculateMainWidth()
  initializeVideoSliders($newVideos)
  initializePlayer($newVideos)
  initializeExpand($newVideos)

prevSlide = ->
  $videoContainer = $(this.closest(".wrapper"))
  navigate($videoContainer, 'prev')
  stopAllVideos()
  updateVideo($videoContainer)

nextSlide = ->
  $videoContainer = $(this.closest(".wrapper"))
  navigate($videoContainer, 'next')
  stopAllVideos()
  updateVideo($videoContainer)

goTo = ($wrapper, index) ->
  navigate($wrapper, index)
  stopAllVideos()
  updateVideo($wrapper)

initializeVideoSliders = ($videos) ->
  $videos.find('.prev').on 'click', prevSlide
  $videos.find('.next').on 'click', nextSlide
  $videos.each (index, video) ->
    hammertime = new Hammer($(video).find('.container')[0], {})
    hammertime.on('swipeleft', nextSlide.bind($(video).find('.container')))
    hammertime.on('swiperight', prevSlide.bind($(video).find('.container')))
    updateVideo($(video))

  $videos.find('.container').on 'transitionend msTransitionEnd webkitTransitionEnd oTransitionEnd', ->
    $wrapper = $(this).closest('.wrapper')
    index = $wrapper.data('index')
    length = $(this).children().length - 2

    $wrapper.data("in_transition", false)

    if index < 0
      $("body").addClass("no-transition")
      setTimeout ->
        goTo($wrapper, length-1)
      , 10
    else if index > length-1
      $("body").addClass("no-transition")
      setTimeout ->
        goTo($wrapper, 0)
      , 10

    setTimeout ->
      $("body").removeClass("no-transition")
      $wrapper.data("in_transition", false)
    , 100


stopAllVideos = ->
  $videos.each (index, video) ->
    $(video).removeClass('playing')

    $medias = $(video).find('.media')

    $medias.each (index, media) ->
      $(media).removeClass('playing loading')

      if (player = $(media).find('iframe')).length > 0
        $f(player[0]).api("pause")

playVideo = (e) ->
  $container = $(e.target).closest('.wrapper')
  $videoContainer = $($container.find('.media').get(getCurrentIndex($container)))

  stopAllVideos()

  setTimeout ->
    $container.addClass('playing')

    id = $videoContainer.data("vimeoId")

    if $videoContainer.children('iframe').length == 0
      $videoContainer.addClass('loading')
      $videoContainer.find('.gradient').after("<iframe id='" + id + "' src='https://player.vimeo.com/video/" + $videoContainer.data("vimeoId") + "?player_id=" + $videoContainer.data("vimeoId") + "&title=0&amp;controls=0&amp;byline=0&amp;portrait=0&amp;color=ffffff' width='593' height='278' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>");
      videoHeight = $container.find('.cover').height()
      $videoContainer.find('iframe').css(height: videoHeight)

      $iframe = $videoContainer.children('iframe')
      player = $f($iframe[0])

      $iframe.on 'load', ->
        players[id] = player

        player.addEvent "ready", ->
          $videoContainer.removeClass('loading').addClass('playing')

          player.api("play")

          player.addEvent "pause", ->
            $videoContainer.add($container).removeClass('playing')

          player.addEvent "finish", ->
            $videoContainer.add($container).removeClass('playing')
    else
      $videoContainer.addClass('playing')

      player = players[id]
      player.api("play")
  , 17


initializePlayer = ($videos) ->
  $videos.find('.player, .mobile-player').on 'click', playVideo


handleExpand = ->
  expandVideo($($(@).closest('.wrapper')))

initializeExpand = ($videos) ->
  $videos.find('.expander').on 'click', handleExpand


$ ->
  initiateInfiniteScroll()

  $('body').css('visibility', 'visible')

  calculateMainWidth()

  $(window).on 'resize orientationchange', ->
    $videos.each (index, video) ->
      if $(video).hasClass('expanded')
        expandVideo($(video))

    calculateMainWidth()

  setTimeout ->
    $('body').removeClass('no-transition')
  , 300

  $('.mobile-menu-button').on 'click', ->
    $('body').toggleClass('menu-opened')

  $('.menu a').on 'click', (event) ->
    event.preventDefault()
    id = $(this).attr('href')

    if $(@).data('loadAll') && ($invisibleVideos.length > 0)
      loadVideos($invisibleVideos)
      $invisibleVideos = []

    scrollToBlock(id)

  $('.root-link').on 'click', scrollToTop

  if location.hash != ''
    scrollToBlock(location.hash)

  initializeVideoSliders($videos)
  initializePlayer($videos)
  initializeExpand($videos)
