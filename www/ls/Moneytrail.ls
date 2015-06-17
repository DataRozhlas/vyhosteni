class ig.Moneytrail
  (@parentElement) ->
    @data = @getData!
    console.log @data.i18n
    @scale = d3.scale.linear!
      ..domain [0 11300000000]
      ..range [0 2200]
    console.log @data.children.length
    @element = @parentElement.append \div
      ..attr \class \moneytrail
      ..selectAll \.col .data @data.children .enter!append \div
        ..attr \class \col
        ..append \span
          ..attr \class \title
          ..html (.title)
        ..append \span
          ..attr \class \value
          ..html ~>
            num = ig.utils.formatNumber it.amount / 1e6, 0, @data.i18n.thousands_separator, @data.i18n.decimal_separator
            "#num #{@data.i18n.millions} €"
        ..append \span
          ..attr \class \text
          ..style \bottom ~> "#{@scale it.amount}px"
          ..html (.text)
        ..append \div
          ..attr \class \area
          ..style \height ~> "#{@scale it.amount}px"

  getData: ->
    ig.data.moneytrail
      ..children.sort (a, b) -> a.amount - b.amount
