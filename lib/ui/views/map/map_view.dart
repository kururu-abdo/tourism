import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final double loc_lat;
  final double loc_lon;
  final String loc_name;
  MapView({Key key, this.loc_lat, this.loc_lon, this.loc_name}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  bool loading = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  Completer<GoogleMapController> controller = Completer();
  static LatLng latLng;
String _mapStyle;
 static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(33.5, 15.6),
    zoom: 5.00,
  );


@override
void initState() {
   rootBundle.loadString('assets/map/style.txt').then((string) {
      _mapStyle = string;
    });
  super.initState();
  
}
  // Future<Uint8List> getMarker() async {
  //   ByteData byteData =
  //       await DefaultAssetBundle.of(context).load("assets/car_icon.png");
  //   return byteData.buffer.asUint8List();
  // }
  void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon:  BitmapDescriptor.defaultMarker ,);
          //BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }
void onCameraMove(CameraPosition position) {
    latLng = position.target;
  }


  // List<LatLng> _convertToLatLng(List points) {
  //   List<LatLng> result = <LatLng>[];
  //   for (int i = 0; i < points.length; i++) {
  //     if (i % 2 != 0) {
  //       result.add(LatLng(points[i - 1], points[i]));
  //     }
  //   }
  //   return result;
  // }

  // void sendRequest() async {
  //   LatLng destination = LatLng(20.008751, 73.780037);
  //   String route =
  //       await _googleMapsServices.getRouteCoordinates(latLng, destination);
  //   createRoute(route);
  //   _addMarker(destination, "KTHM Collage");
  // }

  // void createRoute(String encondedPoly) {
  //   _polyLines.add(Polyline(
  //       polylineId: PolylineId(latLng.toString()),
  //       width: 4,
  //       points: _convertToLatLng(_decodePoly(encondedPoly)),
  //       color: Colors.red));
  // }

  // void _addMarker(LatLng location, String address) {
  //   _markers.add(Marker(
  //       markerId: MarkerId("112"),
  //       position: location,
  //       infoWindow: InfoWindow(title: address, snippet: "go here"),
  //       icon: BitmapDescriptor.defaultMarker));
  // }

  // List _decodePoly(String poly) {
  //   var list = poly.codeUnits;
  //   var lList = new List();
  //   int index = 0;
  //   int len = poly.length;
  //   int c = 0;
  //   do {
  //     var shift = 0;
  //     int result = 0;

  //     do {
  //       c = list[index] - 63;
  //       result |= (c & 0x1F) << (shift * 5);
  //       index++;
  //       shift++;
  //     } while (c >= 32);
  //     if (result & 1 == 1) {
  //       result = ~result;
  //     }
  //     var result1 = (result >> 1) * 0.00001;
  //     lList.add(result1);
  //   } while (index < len);

  //   for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

  //   print(lList.toString());

  //   return lList;
  // }


void getCurrentLocation() async {
    try {
     // Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
        print("Lat:" + location.altitude.toString());

     updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text(widget.loc_name??"MapView"),
      ),
      body: GoogleMap(
       mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(16.940, 33.93),
          zoom: 6.4746,
        ),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onCameraMove: onCameraMove,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _controller.setMapStyle(_mapStyle);
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
}