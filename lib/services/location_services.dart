import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:tourapp/core/models/user_loaction.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';

class LocationServiceProvider  {
  Location location = new Location();
  static TranslatorGenerator _translator = TranslatorGenerator.instance;
  bool _serviceEnabled;

  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<bool> isLocationENabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      return true;
    }
    return false;
  }

  Future<bool> isLocationServiceGanted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    return true;
  }

  Future<bool> requestLocationService() async {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return true;
    }

    return false;
  }

  Future<bool> chekPermision() async {
    var status = await handler.Permission.location.status;
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<Either<UserLocation, LocationException>> requestLocation() async {
    var status = await chekPermision();

    var enabled = await isLocationENabled();
    try {
      if (!await handler.Permission.location.request().isGranted) {
        return right(LocationException(_translator.getLanguageName() == "en"
            ? "Location Service Not Enabled , Enable it and Try Again"
            : "قم بتفعيل خدمات الموقع"));
      } else {
        // final Location location = new Location();
        // location.changeSettings(accuracy: LocationAccuracy.high);

        bool _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return right(LocationException(_translator.getLanguageName() == "en"
                ? "Location Service Not Enabled , Enable it and Try Again"
                : "قم بتفعيل خدمات الموقع"));
          } else {
            _locationData = await location.getLocation();

            return left(UserLocation(
                latitude: _locationData.latitude,
                longitude: _locationData.longitude));
          }
        } else {
           _locationData = await location.getLocation();

          return left(UserLocation(
              latitude: _locationData.latitude,
              longitude: _locationData.longitude));
        }
      }
    } on PlatformException {
      print(
          "-----------------------------------------------------PLATFORM EXCEPTION  -----------------");
      return right(LocationException(_translator.getLanguageName() == "en"
          ? "Location Service Not Enabled , Enable it and Try Again"
          : "قم بتفعيل خدمات الموقع"));
    } on Exception {
      print(
          "-----------------------------------------------------PLATFORM EXCEPTION  -----------------");
      return right(LocationException(_translator.getLanguageName() == "en"
          ? "Location Service Not Enabled , Enable it and Try Again"
          : "قم بتفعيل خدمات الموقع"));
    }
  }

  Future<Either<UserLocation, LocationException>> getLocation() async {
    if (await isLocationENabled()) {
      if (await isLocationServiceGanted()) {
        print("granted");
        // granted
        _locationData = await location.getLocation();

        return left(UserLocation(
            latitude: _locationData.latitude,
            longitude: _locationData.longitude));
      } else {
        return right(LocationException(_translator.getLanguageName() == "en"
            ? "Location Service Not Enabled , Enable it and Try Again"
            : "قم بتفعيل خدمات الموقع"));
      }
    } else {
      if (await requestLocationService()) {
        if (await isLocationServiceGanted()) {
          // granted
          return left(UserLocation(
              latitude: _locationData.latitude,
              longitude: _locationData.longitude));
        } else {
          return right(LocationException(_translator.getLanguageName() == "en"
              ? "Location Service Not Enabled , Enable it and Try Again"
              : "قم بتفعيل خدمات الموقع"));
        }
      } else {
        return right(LocationException(_translator.getLanguageName() == "en"
            ? "Location Service Not Enabled , Enable it and Try Again"
            : "قم بتفعيل خدمات الموقع"));
      }
    }
  }

  //count distance

  Future<double> calculateDistance(LatLng location) async {
    var myLocation = await getLocation();

    return myLocation.fold((l) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((location.latitude - l.latitude) * p) / 2 +
          c(l.latitude * p) *
              c(location.latitude * p) *
              (1 - c((location.longitude - l.longitude) * p)) /
              2;
      return 12742 * asin(sqrt(a));
    }, (r) {
      throw LocationException(_translator.getLanguageName() == "en"
          ? "Location Service Not Enabled , Enable it and Try Again"
          : "قم بتفعيل خدمات الموقع");
    });
  }

//live location

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationServiceProvider() {
    // Request permission to use location
    location.requestPermission().then((status) {
      if (status == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      } else {
        requestLocationService().then((value) {
          if (value) {
            isLocationServiceGanted().then((value) {
              if (value) {
                location.onLocationChanged.listen((locationData) {
                  if (locationData != null) {
                    _locationController.add(UserLocation(
                      latitude: locationData.latitude,
                      longitude: locationData.longitude,
                    ));
                  }
                });
              }
            });
          } else {}
        });
      }
    });
  }
}