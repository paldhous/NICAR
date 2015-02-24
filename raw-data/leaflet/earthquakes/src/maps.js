// creates two basemap layers
var bright = L.tileLayer('https://{s}.tiles.mapbox.com/v3/mapbox.world-bright/{z}/{x}/{y}.png', {
    attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
});
var satellite = L.tileLayer('https://{s}.tiles.mapbox.com/v3/mapbox.blue-marble-topo-jul-bw/{z}/{x}/{y}.png', {
    attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
});

// functions to style the seismic risk layer
function getColor(a) {
            return a > 79 ? '#a50f15':
                   a > 59 ? '#de2d26' :
                   a > 39  ? '#fb6a4A' :
                   a > 19 ? '#fcae91' :
                   '#fee5d9';
            }

function getStyle(feature) {
                return {
                    fillColor: getColor(feature.properties.ACC_VAL),
                    color: getColor(feature.properties.ACC_VAL),
                    weight: 1,
                    opacity: 0.4,
                    fillOpacity: 0.7
                };
            }


// the seismic risks layer, styled using functions above
var seismic = L.geoJson(seismic_risk, {style:getStyle});

// the url to send to the USGS API
var quakedataUrl = 'http://comcat.cr.usgs.gov/fdsnws/event/1/query?starttime=1965-01-01T00:00:00&minmagnitude=6&format=geojson&latitude=39.828175&longitude=-98.5795&maxradiuskm=6000&orderby=magnitude&callback='

// the quakes layer, uses leaflet.ajax to make API call
var quakes = L.geoJson.ajax(quakedataUrl, {

			dataType:'jsonp',

			// calls the function below to create a pop-up for each quake when clicked
			onEachFeature: popupText,

			// makes points into circle markers and styles them, scaling using JavaScript Math; magnitude value for each quake from parsed JSON
			pointToLayer: function (feature, latlng) {
				return L.circleMarker(latlng, {
					radius: Math.sqrt(Math.pow(10, feature.properties.mag)/50000),
					fillColor: "#fff",
					color: "#000",
					weight: 1,
					opacity: 0.2,
					fillOpacity: 0.5
				});
			}
			});

function  popupText (feature, layer) {
	 var date = new Date(feature.properties.time)
	 // uses date-format to format the date
	 var dateString = date.format('mmm d, yyyy')
	 layer.bindPopup('<strong>Date: </strong>' + dateString + '<br />'
					+ '<strong>Magnitude: </strong>' + feature.properties.mag + '<br />'
					+ '<strong>Depth: </strong>' + feature.geometry.coordinates[2] + ' kilometers')
}

// creates the map and sets initial view, including layers to be displayed, plus limits for zoom and maximum extent
var map = L.map('map', {
    center: new L.LatLng(40, -100),
    zoom: 4,
    maxZoom: 6,
    minZoom: 3,
    maxBounds: ([
    [-10, -160],
    [70, -40]
    ]),
    layers: [bright, seismic, quakes]
});

// Defines the two basemaps
var baseMaps = {
    'Satellite': satellite,
    'Map': bright
};

// Defines the overlay maps. For now this variable is empty, because we haven't created any overlay layers
var overlayMaps = {
	'Seismic risk': seismic,
	'Earthquakes': quakes
};

// Adds a Leaflet layer control, using basemaps and overlay maps defined above
var layersControl = new L.Control.Layers(baseMaps, overlayMaps, {collapsed: false});
map.addControl(layersControl);

// Uses jQuery to add some responsive design, resetting zoom levels for small and very large screens
function responsive() {
     width = $(window).width();
     height = $(window).height();
    if (width < 768) {
        // set the zoom level to 3
        map.setZoom(3);
    } else if (width > 1500) {
        // set the zoom level to 5
        map.setZoom(5);
    } else {
    	map.setZoom(4);
    }
 }

  // applies the function above both on initial load and window resize
   $(window).ready(responsive).resize(responsive);
