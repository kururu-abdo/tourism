import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tourapp/core/enums/trip_status.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/trip.dart';
import 'package:tourapp/core/services/dialog_services.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/DBhelper.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/services/notifications.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

import '../locator.dart';

enum TripViewState { Loading, Error, Loaded }

class TripViewModel extends BaseModel {
    final DialogService _dialogService = locator<DialogService>();
         var translator = locator.get<TranslationServices>();

Widget getErrWidget(AppException error, VoidCallback onPress) {
    if (error is ServerException) {
      return ErrorScreen(
        msg: translator.getString(SERVERER),
        img: IMG_500,
        onPress: onPress,
      );
    }
    if (error is UnauthorisedException) {
      return ErrorScreen(
        msg: translator.getString(UNAUTH_ERROR),
        img: IMG_403,
        onPress: onPress,
      );
    }

    if (error is ConnectionException) {
      return ErrorScreen(
        msg: translator.getString(CONNECTION_ERR),
        img: IMG_303,
        onPress: onPress,
      );
    }

    if (error is NotFoundException) {
      return ErrorScreen(
        msg: translator.getString(NOTFOUND_ERR),
        img: IMG_404,
        onPress: onPress,
      );
    }
    if (error is MyTimeoutConnection) {
      return ErrorScreen(
        msg: translator.getString(CONNECTIONTIMEOUT_ERR),
        img: IMG_404,
        onPress: onPress,
      );
    }
    return ErrorScreen(
      msg: translator.getString(UNKNOWN_ERR),
      img: IMG_800,
      onPress: onPress,
    );
  }

  API api = locator<API>();
   DBHelper db = locator<DBHelper>();
  // Future<List<TourismLocation> >   locations=[];
  // TourismLocation  location;
  AppException _error;
  AppException get error => _error;

  _setError(AppException error) {
    _error = error;
    notifyListeners();
  }

  TripViewState _tripViewState;
  TripViewState get tripState => _tripViewState;

  _setState(TripViewState state) {
    _tripViewState = state;
    notifyListeners();
  }

  List<Trip> _trips = [];

  List<Trip> get trips => _trips;

  _updateTrips(List<Trip> trips) {
    _trips = trips;
    notifyListeners();
  }


  getAllScheduledTrips()async{
    _setState(TripViewState.Loading);
    try {
      var data = await db.getAllScheduledTrips();
      _setState(TripViewState.Loaded);
      _updateTrips(data);
    
    }
     catch (e) {
      _setState(TripViewState.Error);
      _updateTrips([]);
      _setError(checkError(800));
    }
  }

 cancelTrip(Trip trip)async{

try {
  var newTrip = trip;
  newTrip.status=TripStatus.CANCELED;

      var data = await db.delete(newTrip.id);
    await  cancelScheduledNotification(trip.id);
await  getAllScheduledTrips();

    } catch (e) {
      print(e);
      _setState(TripViewState.Error);
      _setError(checkError(800));
    }

 }



 String getFormatedDate(String tod){
  return DateFormat("yyyy/MM/dd hh:mm a", "en_US")
        // .add_jm()
        .format(DateTime.parse(tod));

 }

  int ErrorCode;
  initiState() {}
  void addTrip(Trip model) async {
        _setState(TripViewState.Loading);

    try {
      print(
          "--------------------------------------------ADD TRIP----------------");
      var result = DBHelper.db.add(model);
          _setState(TripViewState.Loaded);

      print(result);
    } on Exception {
          _setState(TripViewState.Loaded);

      throw Exception("Local Databse Not Ready yet");
    }
  }

  Future<List<Trip>> getAllTrips() async {
    try {
      print(
          "--------------------------------------------GET TRIPS----------------");
      var result = await DBHelper.db.getAllScheduledTrips();
      return result ?? [];
    } on Exception {
      throw Exception("Local Databse Not Ready yet");
    }
  }

  Future<List<TourismLocation>> getLocations() async {
    //  setState(ViewState.Busy);
    var result = await API.fetchLocations();
    if (!result.error) {
      //    setState(ViewState.Idle);

      return result.data;
    } else {
      // setState(ViewState.Idle);
      showErrorWidget(result.statusCode);
    }
  }

  Future<List<TourismLocation>> searcLocations(String loc) async {
    var locations = await getLocations();
    return locations
        .where((element) =>
            element.locationArName.contains(loc) ||
            element.locationEnName.toLowerCase().contains(loc))
        .toList();
  }

  Exception showErrorWidget(int code) {
    switch (code) {
      case 500:
        return BadRequestException("Server Error");
        break;
      case 404:
        return NotFoundException("Not Found");
        break;
      case 403:
        return UnauthorisedException(
            "your are not authorized to access this resource now");
        break;

      default:
        return UnknownException("Unknown Exception ");
    }
  }

  AppException checkError(int code) {
    switch (code) {
      case 500:
        return BadRequestException("Server Error");
        break;
      case 404:
        return NotFoundException("Not Found");
        break;
      case 403:
        return UnauthorisedException(
            "your are not authorized to access this resource now");
        break;
      case 303:
        return ConnectionException("Check your internet exception");
        break;
      default:
        return UnknownException("Unknown Exception ");
    }
  }
}
