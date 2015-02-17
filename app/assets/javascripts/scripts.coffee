gutterSize = 35
$main      = $('#main > .wrapper')
$videos    = $('#work > article')
$header    = $('body > header > .wrapper')
$news      = $('#news article')

calculateMainWidth = ->
  windowWidth   = $(window).width()

  if windowWidth > 768
    blockWidth    = windowWidth - 4 * gutterSize

    gutterNumber = Math.floor(blockWidth / gutterSize)

    marginNumber = 2

    if gutterNumber % 2 == 0
      gutterNumber -= 1
      marginNumber = 3

    newWidth = gutterNumber * gutterSize + 2

    $main.add($header).css(
      'margin-left': marginNumber * gutterSize - 2
      'width': newWidth
    )

    $news.css(width: (newWidth - gutterSize)/2)

assignMargins = ->
  smallVideoCount = 0

  $videos.each (index, video) ->
    if $(video).hasClass('big')
      smallVideoCount = 0
    else
      smallVideoCount += 1

      if smallVideoCount % 2 == 0
        $(video).css('margin-right', 0)

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

expandNews = ->
  $news = $('#news')

  $news.toggleClass('expanded')

  if $news.hasClass('expanded')
    width = $news.width()

    $news.height(width + 4 * gutterSize)
    $news.find('.cover').height(width + 2)
  else
    $news.height(5 * gutterSize - 2)
    $news.find('.cover').css('height', '100%')

currentNewsIndex = 0
$newsContainer   = $('#news .container')
newsNumber       = $newsContainer.children().length

updateNews = ->
  $block = $($newsContainer.children().get(currentNewsIndex))

  $('#news .date').text($block.data('date'))

  if currentNewsIndex == 0
    $('.prev i').hide();
    $('.next i').show();
  else if currentNewsIndex == newsNumber - 1
    $('.prev i').show();
    $('.next i').hide();
  else
    $('.next i, .prev i').show();

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
  calculateMainWidth()
  assignMargins()
  $('body').css('visibility', 'visible')

  $(window).resize(calculateMainWidth)

  player = null

  $('#about .expander').on 'click', ->
    expandAbout()

  $('#news .expander').on 'click', ->
    expandNews()

  $('.prev').on 'click', ->
    navigateNews('prev')

  $('.next').on 'click', ->
    navigateNews('next')

  updateNews()

  $('.player').on 'click', (e) ->
    $container = $(e.target).parents('article')

    $container.addClass('loading')

    if $container.children('iframe').length == 0
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
      $container.addClass('playing').removeClass('loading')
      
      player = $f($container.children('iframe')[0])
      player.api("play")