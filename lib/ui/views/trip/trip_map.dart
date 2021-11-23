import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/ui/shared/app.dart';
import 'package:tourapp/viewmodels/Weather_Map_ViewModel.dart';
import 'package:weather_widget/WeatherWidget.dart';
class TripMap extends StatefulWidget {
  final LatLng destination;
  final  String destination_name;
  TripMap({Key key, this.destination, this.destination_name}) : super(key: key);

  @override
  _TripMapState createState() => _TripMapState();
}

class _TripMapState extends State<TripMap> {


GoogleMapController mapController;
Location location =  Location();

  double _originLatitude = 26.48424, _originLongitude = 50.04551;
  double _destLatitude , _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey =  GoogleMapKey;
  double distance=0.0;
String _mapStyle;

@override
void initState() {
    super.initState();
    _destLatitude =widget.destination.latitude;
    _destLongitude=widget.destination.longitude;
    //load  map  theme
   rootBundle.loadString('assets/map/style.txt').then((string) {
      _mapStyle = string;
    });
    Future.microtask(() async{
context.read<WeatherMapViewModel>().fetchWeatherData(LatLng(_destLatitude, _destLongitude),
          Provider.of<TranslationProvider>(context ,listen: false).getCurrentLang()=="en"?"en":"ar");
    });
    /// origin marker
      // _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
      //   BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();


    ///listen to location changes

}



  
void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);



        location.onLocationChanged.listen((l ) {
       if(mounted){
             setState(() {
          _originLatitude = l.latitude;
          _originLongitude = l.longitude;
          markers.remove("origin");

          _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
              BitmapDescriptor.defaultMarker);
        });
       }
      //Use current location_
 mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 5)),
      );
    _getPolyline();

    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
if(mounted){
  
    setState(() {
        polylines.remove("poly");
        polylineCoordinates.add(position);
      });
}
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
if(mounted){
      setState(() {});
}
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
       );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
  @override
  Widget build(BuildContext context) {
        var translator = Provider.of<TranslationProvider>(context);

    return Directionality(
      textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
         body: Stack(
      children: <Widget>[
      GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_originLatitude, _originLongitude), zoom: 15),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
        ) ,
    
    
        Positioned(child:  Container(
          height: 60,
          decoration: BoxDecoration(
                    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(30))
     ,
     boxShadow: [
       BoxShadow(
     color: Colors.grey,
    spreadRadius: 3.0,
    blurRadius: 7.0,
    
       )
     ]
          ),
          child: Center(child: Text(widget.destination_name),),
        ) , top: 30 ,  left: MediaQuery.of(context).size.width/2,),
    
    
       Positioned(
              child: Container(
                height: 150,
                width: 120,
              padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3.0,
                        blurRadius: 7.0,
                      )
                    ]),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.destination_name),
                      Text( 
                        translator.getCurrentLang()=="en"?
                        
                       formatDistance(calculateDistance(
                                      LatLng(_destLatitude, _destLongitude)))
                              .toString() +  "    "+"K.M" :   
                                   formatDistance(calculateDistance(
                                      LatLng(_destLatitude, _destLongitude)))
                                  .toString() +
                              "    " +
                              "كم " 
                              
                              )
                    ],
                  ),
                ),
              ),
              bottom: 30,
              left: 50,
            ),
      Positioned(
              child: Container(
                height: 150,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3.0,
                        blurRadius: 7.0,
                      )
                    ]),
                child: 
                Consumer<WeatherMapViewModel>(builder: (context , model ,  _){
                      if(model.state==WeatherMapState.Loading){
      return Center(
                  child:  CircularProgressIndicator(strokeWidth: 1.5,));
                      }
      else if(model.state == WeatherMapState.Error){
    return Center(child: Text("Error"));
      }
                  return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                Text(model.currentWeatherResponse.weather[0].description) ,
    
                                          Image.network(
                              'https://openweathermap.org/img/w/${model.currentWeatherResponse.weather[0].icon}.png'),
    
         
                     Text('${model.currentWeatherResponse.main.temp}°', style: new TextStyle(color: Colors.black)),
                    ],
                  ),
                );
                })
    
    
              ),
              bottom: 30,
              right: 50,
            ),
       ],
       ),
      ),
    );
  }


//distance
double  calculateDistance(LatLng location)  {
  

 
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((location.latitude -_originLatitude) * p) / 2 +
          c(_originLatitude * p) *
              c(location.latitude * p) *
              (1 - c((location.longitude - _originLongitude) * p)) /
              2;
      return 12742 * asin(sqrt(a));
    
  }


 double formatDistance(double x) {
    return (x * 1000).ceil() / 1000;
  }


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}