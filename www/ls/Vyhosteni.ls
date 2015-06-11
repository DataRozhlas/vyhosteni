class ig.Vyhosteni
  (@parentElement) ->
    @data = @getData!
    @scale = d3.scale.linear!
      ..domain [0 4754]
      ..range [0 70]
    @parentElement.append \ol
      ..attr \class \vyhosteni
      ..selectAll \li .data @data .enter!append \li
        ..append \span
          ..attr \class \title
          ..html -> it.country
        ..append \div
          ..attr \class \bar-container
          ..append \div
            ..attr \class \bar
            ..style \width ~> "#{@scale it.total}%"
            ..append \span
              ..attr \class \count
              ..html (d, i) ->
                t = ig.utils.formatNumber d.total
                if i == 0
                  t += " vyhoštěných"
                t

  getData: ->
    @data = d3.tsv.parse ig.data.vyhosteni, (row) ->
      row.total = 0
      for i in [2010 to 2014]
        row[i] = parseInt row[i], 10
        row.total += row[i]
      row

