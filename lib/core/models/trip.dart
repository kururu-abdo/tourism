import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tourapp/core/enums/trip_status.dart';

class Trip {
int id;
String location;
double lat;
double lon;
String message;
String date;
TripStatus  status;

Trip({this.id , this.location ,  this.lat ,  this.lon, this.message  ,  this.status  , this.date}) ;

Trip.fromJson(Map<dynamic  , dynamic>  data ) {

  this.id = data["id"];
 this.date = data["date"];
 this.location = data["location"];
 this.message =  data["mesage"]??"Your trip  should begin now";

 this.lat = data["lat"];
 this.lon=data["lon"];

 this.status =   _getTripStatus(data["status"]);


}

Map<String  , dynamic>  toJson() =>{

  "id" :  this.id  ,
  "location" :  this.location ,
  "message" :  this.message??"Your trip  should begin now" ,
 "lat" :  this.lat,
  "lon": this.lon ,
  "status" :  this.status.toString() ,
  "date":  this.date
};


 static TripStatus   _getTripStatus(String status) {
    for (TripStatus state   in TripStatus.values) {
      debugPrint("-------TRIP STATE ENUM--------------");
      if (state.toString() == status) {
              debugPrint(state.toString());

        return state;
      }
    }

    return null;
  }





}
