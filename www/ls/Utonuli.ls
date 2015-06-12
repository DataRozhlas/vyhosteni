class ig.Utonuli
  (@parentElement) ->
    @element = @parentElement.append \div
      ..attr \class \utonuli
    @prepareMap!
    @data = ig.data.utonuli
    @radiusScale = d3.scale.sqrt!
      ..domain [0 29986]
      ..range [1 70]

    console.log d3.extent @data.features.map (.properties.deaths)
    @markers = @data.features
      .filter -> it.geometry
      .sort (a, b) -> b.properties.deaths - a.properties.deaths
      .map (feature) ~>
        return unless feature.geometry
        [lon, lat] = feature.geometry.coordinates
        options =
          color: \#ab0000
          fillOpacity: 0.8
          stroke: no
          radius: @radiusScale feature.properties.deaths

        circle = L.circleMarker do
          [lat, lon]
          options
        circle.addTo @map
        circle

    console.log @data


  prepareMap: ->
    @map = L.map do
      * @element.node!
      * minZoom: 3,
        maxZoom: 7,
        zoom: 3,
        center: [29, 15.5]
    baseLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
      * zIndex: 1
        attribution: 'CC BY-NC-SA <a href="http://rozhlas.cz">Rozhlas.cz</a>. Data <a href="https://www.czso.cz/" target="_blank">ČSÚ</a>, mapová data &copy; <a target="_blank" href="http://osm.org">OpenStreetMap</a>, podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

    labelLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_l1/{z}/{x}/{y}.png"
      * zIndex: 3
        opacity: 0.8
    baseLayer.addTo @map
    labelLayer.addTo @map
    @map
