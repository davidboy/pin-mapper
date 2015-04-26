(function() {
  var map = L.map('map', { minZoom: 4, maxZoom: 9, worldCopyJump: true }).setView([33.520, -86.802], 5);
  L.tileLayer("<%= @tile_layer %>", {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png"><% if @satellite then %>, Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency<% end %>',
    maxZoom: 9
  }).addTo(map);
})();