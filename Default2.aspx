﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
		<title>OpenSeaMap</title>

		<!-- bring in the OpenLayers javascript library
			(here we bring it from the remote site, but you could
			easily serve up this javascript yourself) -->
		<script src="http://www.openlayers.org/api/OpenLayers.js"></script>

		<!-- bring in the OpenStreetMap OpenLayers layers.
			Using this hosted file will make sure we are kept up
			to date with any necessary changes -->
		<script src="http://www.openstreetmap.org/openlayers/OpenStreetMap.js"></script>
		<script type="text/javascript" src="http://map.openseamap.org/map/javascript/harbours.js"></script>
		<script type="text/javascript" src="http://map.openseamap.org/map/javascript/map_utils.js"></script>
		<script type="text/javascript">

			var map;
			var layer_mapnik;
			var layer_seamark;
			var marker;

			// Position and zoomlevel of the map
			var lon = 12.0915;
			var lat = 54.1878;
			var zoom = 15;
				
			var linkText = "Description by SkipperGuide";
			
			function jumpTo(lon, lat, zoom) {
				var x = Lon2Merc(lon);
				var y = Lat2Merc(lat);
				map.setCenter(new OpenLayers.LonLat(x, y), zoom);
				return false;
			}

			function Lon2Merc(lon) {
				return 20037508.34 * lon / 180;
			}

			function Lat2Merc(lat) {
				var PI = 3.14159265358979323846;
				lat = Math.log(Math.tan( (90 + lat) * PI / 360)) / (PI / 180);
				return 20037508.34 * lat / 180;
			}

			function addMarker(layer, lon, lat, popupContentHTML) {
				var ll = new OpenLayers.LonLat(Lon2Merc(lon), Lat2Merc(lat));
				var feature = new OpenLayers.Feature(layer, ll);
				feature.closeBox = true;
				feature.popupClass = OpenLayers.Class(OpenLayers.Popup.FramedCloud, {minSize: new OpenLayers.Size(260, 100) } );
				feature.data.popupContentHTML = popupContentHTML;
				feature.data.overflow = "hidden";

				marker = new OpenLayers.Marker(ll);
				marker.feature = feature;

				var markerClick = function(evt) {
					if (this.popup == null) {
						this.popup = this.createPopup(this.closeBox);
						map.addPopup(this.popup);
						this.popup.show();
					} else {
						this.popup.toggle();
					}
					OpenLayers.Event.stop(evt);
				};
				marker.events.register("mousedown", feature, markerClick);

				layer.addMarker(marker);
				map.addPopup(feature.createPopup(feature.closeBox));
			}

			function getTileURL(bounds) {
				var res = this.map.getResolution();
				var x = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
				var y = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
				var z = this.map.getZoom();
				var limit = Math.pow(2, z);
				if (y < 0 || y >= limit) {
					return null;
				} else {
					x = ((x % limit) + limit) % limit;
					url = this.url;
					path= z + "/" + x + "/" + y + "." + this.type;
					if (url instanceof Array) {
						url = this.selectUrl(path, url);
					}
					return url+path;
				}
			}

			function drawmap() {


				map = new OpenLayers.Map('map', {
					projection: new OpenLayers.Projection("EPSG:900913"),
					displayProjection: new OpenLayers.Projection("EPSG:4326"),
					eventListeners: {
						"moveend": mapEventMove,
						//"zoomend": mapEventZoom
					},
					controls: [
						new OpenLayers.Control.Navigation(),
						new OpenLayers.Control.ScaleLine({topOutUnits : "nmi", bottomOutUnits: "km", topInUnits: 'nmi', bottomInUnits: 'km', maxWidth: '40'}),
						new OpenLayers.Control.LayerSwitcher(),
						new OpenLayers.Control.MousePosition(),
						new OpenLayers.Control.PanZoomBar()],
						maxExtent:
						new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34),
					numZoomLevels: 18,
					maxResolution: 156543,
					units: 'meters'
				});

				// Add Layers to map-------------------------------------------------------------------------------------------------------
				// Mapnik
				layer_mapnik = new OpenLayers.Layer.OSM.Mapnik("Mapnik");
				// Seamark
				layer_seamark = new OpenLayers.Layer.TMS("Seezeichen", "http://t1.openseamap.org/seamark/", { numZoomLevels: 18, type: 'png', getURL: getTileURL, isBaseLayer: false, displayOutsideMaxExtent: true});
				// Harbours
				layer_harbours = new OpenLayers.Layer.Markers("Häfen", { projection: new OpenLayers.Projection("EPSG:4326"), visibility: true, displayOutsideMaxExtent:true});
				layer_harbours.setOpacity(0.8);
				
				map.addLayers([layer_mapnik, layer_seamark, layer_harbours]);
				jumpTo(lon, lat, zoom);

				// Update harbour layer
				refresh_oseamh();
			}

			// Map event listener moved
			function mapEventMove(event) {
				// Update harbour layer
				refresh_oseamh();
			}
	</script>

</head>

<!-- body.onload is called once the page is loaded (call the 'init' function) -->
<body onload="drawmap();">

    <!-- define a DIV into which the map will appear. Make it take up the whole window -->
    <div style="width:100%; height:100%" id="map"></div>

</body>

</html>
