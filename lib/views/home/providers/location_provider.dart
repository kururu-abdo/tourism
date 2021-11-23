import 'package:flutter/material.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/tour_location.dart';
import 'package:tourapp/services/API.dart';

class LocationProvider extends ChangeNotifier {
  List<TourismLocation> locations  =[];




 Future<void> fetchLocations()async{
   try {
   var fetchlocations=  await  API.fetchLocations();
   if(!fetchlocations.error){
     locations = fetchlocations.data;
   notifyListeners();
   }


   } catch (e) {
   }

 }



 Future<void> filterLocations(List tags ,List types) async {
    notifyListeners();
  }



}