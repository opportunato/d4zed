gutterSize = 35
$main      = $('#main > .wrapper')
$header    = $('body > header > .wrapper')

calculateLeftMargin = ->
  $windowWidth   = $(window).width()
  $blockWidth    = $main.width()

  newWidth = Math.floor($blockWidth / gutterSize) * gutterSize + 2

  $main.add($header).css(
    'margin-left': 2 * gutterSize  - 2
    'width': newWidth
  )


$ ->
  calculateLeftMargin()
  $('body').css('visibility', 'visible')

  $(window).on 'resize', calculateLeftMargin

  player = null

  $('.player').on 'click', (e) ->
    $container = $(e.target).parents('article')

    $container.addClass('playing')

    if $container.children('iframe').length == 0
      $container.append("<iframe src='//player.vimeo.com/video/" + $container.data("vimeoId") + "?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff' width='560' height='315' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>");
  
      if player
        player.api("pause");
      
      player = $f($container.children('iframe')[0])

      player.addEvent "ready", ->
        player.api("play")
        
        player.addEvent "finish", ->
          $container.removeClass('playing')

        player.addEvent "pause", ->
          $container.removeClass('playing')

    else
      $container.children("iframe").show()
      
      player = $f($container.children('iframe')[0])
      player.api("play")