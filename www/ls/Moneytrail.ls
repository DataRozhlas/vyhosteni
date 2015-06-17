class ig.Moneytrail
  (@parentElement) ->
    @data = @getData!
    @scale = d3.scale.linear!
      ..domain [0 11300000000]
      ..range [0 2200]
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
        ..append \div
          ..attr \class \area
          ..style \height ~> "#{@scale it.amount}px"
          ..selectAll \div.sub .data (-> it.subnodes || []) .enter!append \div
            ..attr \class \sub
            ..attr \data-size (d, i, ii) ~> "#{(d.amount / @data.children[ii].amount) * 100}%"
        ..append \div
          ..attr \class \text
          ..style \bottom ~> "#{@scale it.amount}px"
          ..html (.text)
          ..selectAll \div.sub-title .data (-> it.subnodes || []) .enter!append \div
            ..attr \class \sub-title
            ..append \h2
              ..html ~> "#{it.title}: #{ig.utils.formatNumber it.amount / 1e6, 0, @data.i18n.thousands_separator} #{@data.i18n.millions_abbrev} €"
            ..append \span
              ..html -> it.text

  getData: ->
    ig.data.moneytrail
      ..children.sort (a, b) -> a.amount - b.amount
