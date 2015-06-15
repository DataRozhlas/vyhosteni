class ig.VyhosteniStaty
  (@parentElement) ->
    @data = @getData!
    @scale = d3.scale.linear!
      ..domain [0 48 / 1e4]
      ..range [0 55]
    @element = @parentElement.append \ol
      ..attr \class "vyhosteni staty"
      ..selectAll \li .data @data .enter!append \li
        ..style \top (d, i) -> "#{i * 30}px"
        ..append \span
          ..attr \class \title
          ..html -> it.country
        ..append \div
          ..attr \class \bar-container
          ..append \div
            ..attr \class \bar
            ..style \width ~> "#{@scale it.rate}%"
            ..append \span
              ..attr \class \count
              ..html (d, i) ->
                t = ig.utils.formatNumber d.rate * 1e4, 2
                if i == 0
                  t += " vyhoštěných na 1 000 obyv."
                t

  getData: ->
    data = d3.tsv.parse ig.data['deportace-eu'], (row) ->
      validValues = 0
      sum = 0
      row.population = parseInt row.population, 10
      row.years = for i in [2008 to 2014]
        row[i] = parseInt row[i], 10
        unless isNaN row[i]
          sum += row[i]
          validValues++
        {year: i, value: row[i]}
      row.average = sum / validValues
      row.rate = row.average / row.population
      row

    data.sort (a, b) -> a.rate - b.rate
    data
