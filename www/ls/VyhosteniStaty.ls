class ig.VyhosteniStaty
  (@parentElement) ->
    @data = @getData!
    @scale = d3.scale.linear!
      ..domain [0 4754]
      ..range [0 55]
    @element = @parentElement.append \ol
      ..attr \class \vyhosteni
      ..selectAll \li .data @data .enter!append \li
        ..style \top (d, i) -> "#{i * 30}px"
        ..style \z-index (d, i) -> 100 - i
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
                t += " <span>("
                t += ig.utils.formatNumber d.totalDeportace
                if i == 0
                  t += " deportovaných"
                t += ")</span>"
                t
          ..append \div
            ..attr \class "bar deportace"
            ..style \width ~> "#{@scale it.totalDeportace}%"
        ..append \div
          ..attr \class \details
          ..selectAll \div.col .data (.years) .enter!append \div.col
            ..attr \class \col
            ..append \div
              ..attr \class \line
              ..style \bottom -> "#{it.scaled * 100}%"
              ..html (.value)
            ..append \span
              ..attr \class \year
              ..html (.year)
    @moreButton = @parentElement.append \button
      ..attr \class \more-button
      ..on \click ~>
        @element.classed \all yes
        @moreButton.remove!
      ..html "Zobrazit další"

  getData: ->
    dataAssoc = []
    @data = d3.tsv.parse ig.data.vyhosteni, (row) ->
      row.total = 0
      max = -Infinity
      row.years = for i in [2010 to 2014]
        row[i] = parseInt row[i], 10
        max = row[i] if row[i] > max
        row.total += row[i]
        {year: i, value: row[i]}
      row.scale = d3.scale.linear!
        ..domain [0 max]
      for year in row.years
        year.scaled = row.scale year.value
      dataAssoc[row.country] = row
      row
