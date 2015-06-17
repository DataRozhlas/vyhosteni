class ig.Utonuli
  (@parentElement) ->
    @element = @parentElement.append \div
      ..attr \class \utonuli
    @prepareMap!
    @data = ig.data.utonuli
    @radiusScale = d3.scale.sqrt!
      ..domain [0 29986]
      ..range [1 70]

    @setPoints!
    @setVoronoi!
    @map.on \zoomend @~setMarkerRadii

  setMarkerRadii: ->
    zoom = @map.getZoom!
    zoomFromStart = Math.max 0, zoom - 3
    rangeStart = Math.min
      2 ^ zoomFromStart
      8
    @radiusScale.range [rangeStart, 70 * (zoomFromStart || 1)]
    console.log @radiusScale.range!
    @points.forEach ~>
      it.marker.setRadius @radiusScale it.incident.deaths

  setPoints: ->
    @points = @data.features
      .filter -> it.geometry
      .sort (a, b) -> b.properties.deaths - a.properties.deaths
      .map (feature) ~>
        return unless feature.geometry
        [lon, lat] = feature.geometry.coordinates
        options =
          color: \#ab0000
          fillOpacity: 0.6
          stroke: no
          radius: @radiusScale feature.properties.deaths
        latLng = L.latLng [lat, lon]
        point = L.Projection.SphericalMercator.project latLng
        marker = L.circleMarker do
          latLng
          options
        marker
          ..bindPopup switch
            | feature.properties.deaths == 1
              "Na tomto místě od roku 2000 zahynul <b>#{feature.properties.deaths}</b> uprchlík"
            | 1 < feature.properties.deaths < 5
              "Na tomto místě od roku 2000 zahynuli <b>#{feature.properties.deaths}</b> uprchlíci"
            | otherwise
              "Na tomto místě od roku 2000 zahynulo <b>#{ig.utils.formatNumber feature.properties.deaths}</b> uprchlíků"
          ..addTo @map
        incident = feature.properties
        {point, marker, incident}

  setVoronoi: ->
    voronoi = d3.geom.voronoi!
      ..x ~> it.point.x
      ..y ~> it.point.y
      ..clipExtent [[-Math.PI, -Math.PI], [Math.PI, Math.PI]]
    polygons = voronoi @points
      .filter -> it
    polygons.forEach (polygon) ~>
      latLngs = for point in polygon
        L.Projection.SphericalMercator.unproject L.point point
      polygon.point.voronoiPath = latLngs
      polygon.point.voronoiPolygon = L.polygon latLngs, {stroke: no, fillColor: \transparent}
        ..on \mouseover ~>
          polygon.point.marker.openPopup!
          polygon.point.marker.setStyle color: \#fa0000, fillOpacity: 1
        ..on \mouseout ~>
          polygon.point.marker.setStyle color: \#ab0000, fillOpacity: 0.6
        ..addTo @map

  prepareMap: ->
    @map = L.map do
      * @element.node!
      * minZoom: 3,
        maxZoom: 7,
        zoom: 4,
        center: [29, 15.5]
        scrollWheelZoom: no
    baseLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
      * zIndex: 1
        opacity: 0.3
        attribution: 'CC BY-NC-SA <a href="http://rozhlas.cz">Rozhlas.cz</a>. Data <a href="https://www.czso.cz/" target="_blank">ČSÚ</a>, mapová data &copy; <a target="_blank" href="http://osm.org">OpenStreetMap</a>, podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

    labelLayer = L.tileLayer do
      * "https://samizdat.cz/tiles/ton_l1/{z}/{x}/{y}.png"
      * zIndex: 3
        opacity: 0.8
    baseLayer.addTo @map
    labelLayer.addTo @map
    @map
