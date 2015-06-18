shareUrl = window.location

ig.fit = ->
  return unless $?
  $body = $ 'body'
  $hero = $ "<div class='hero'></div>"
    ..append "<div class='overlay'></div>"
    ..append "<span class='copy'><span class='title'><em>Syrští uprchlíci <a href='http://reportermagazin.cz/a-pred-nami-je-stesti/' target='_blank'>dopadení</a> egyptskou policií</em><br>na ostrůvku u přístavu Alexandrie.</span>foto: <a href='http://www.krupar.com/' target='_blank'>Stanislav Krupař</a></span>"
    ..append "<a href='#' class='scroll-btn'>Číst dál</a>"
    ..find 'a.scroll-btn' .bind 'click touchstart' (evt) ->
      evt.preventDefault!
      offset = $filling.offset!top + $filling.height! - 50
      d3.transition!
        .duration 800
        .tween "scroll" scrollTween offset
  $body.prepend $hero

  $ '#article h1' .html 'Kolik nás stojí &bdquo;pevnost Evropa&#8221;'
  $ '#article .perex' .html 'Za utěsnění hranic před uprchlíky zaplatí Evropané každý rok přes miliardu eur. Běženci dají zhruba stejnou částku převaděčům, aby je přes tyto bariéry dostali. Patnáct novinářů z devíti zemí pátralo po tom, jak protiimigrační opatření Evropské unie fungují, kdo na nich<br>profituje – a kdo na ně doplácí.'

  $filling = $ "<div class='ig filling'></div>"
    ..css \height $hero.height! + 50
  $ "p.perex" .after $filling

  $shares = $ "<div class='shares'>
    <a class='share cro' title='Zpět nahoru' href='#'><img src='https://samizdat.cz/tools/cro-logo/cro-logo-light.svg'></a>
    <a class='share fb' title='Sdílet na Facebooku' target='_blank' href='https://www.facebook.com/sharer/sharer.php?u=#shareUrl'><img src='https://samizdat.cz/tools/icons/facebook-bg-white.svg'></a>
    <a class='share tw' title='Sdílet na Twitteru' target='_blank' href='https://twitter.com/home?status=#shareUrl'><img src='https://samizdat.cz/tools/icons/twitter-bg-white.svg'></a>
  </div>"
  $body.prepend $shares
  sharesTop = $shares.offset!top
  sharesFixed = no

  $ window .bind \resize ->
    $shares.removeClass \fixed if sharesFixed
    sharesTop := $shares.offset!top
    $shares.addClass \fixed if sharesFixed
    $filling.css \height $hero.height! + 50


  $ window .bind \scroll ->
    top = (document.body.scrollTop || document.documentElement.scrollTop)
    if top > sharesTop and not sharesFixed
      sharesFixed := yes
      $shares.addClass \fixed
    else if top < sharesTop and sharesFixed
      sharesFixed := no
      $shares.removeClass \fixed
  $shares.find "a[target='_blank']" .bind \click ->
    window.open do
      @getAttribute \href
      ''
      "width=550,height=265"
  $shares.find "a.cro" .bind \click (evt) ->
    evt.preventDefault!
    d3.transition!
      .duration 800
      .tween "scroll" scrollTween 0
  <~ $
  $ '#aside' .remove!

scrollTween = (offset) ->
  ->
    interpolate = d3.interpolateNumber do
      window.pageYOffset || document.documentElement.scrollTop
      offset
    (progress) -> window.scrollTo 0, interpolate progress
