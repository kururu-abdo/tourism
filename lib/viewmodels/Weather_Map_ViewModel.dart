import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourapp/core/models/current_weather_model.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/shared/app.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

enum WeatherMapState{

Loading , Loaded   ,   Error
}
class WeatherMapViewModel  extends ChangeNotifier{
         var translator = locator.get<TranslationServices>();

   CurrentWeatherResponse _currentWeatherResponse;

CurrentWeatherResponse get currentWeatherResponse =>_currentWeatherResponse;
  WeatherMapState _state;
  WeatherMapState get state =>_state;
  AppException _exception;
  AppException get exception => _exception;

  _setState(WeatherMapState state) {
    _state =state;
    notifyListeners();
  }
  _setError(AppException exception){
    _exception=exception;

    notifyListeners();
  }
  _updateWeather(CurrentWeatherResponse currentWeatherResponse){
    _currentWeatherResponse = currentWeatherResponse;
    notifyListeners();
  }


  fetchWeatherData(LatLng position , String lang) async {
        _setState(WeatherMapState.Loading);

    var res = await API.getCurrentWeatherInfo(position , lang);
    print("WEATHER"+ res.data.toString());
    if(!res.error){
      print("-------"+  res.data.toJson().toString());
          _setState(WeatherMapState.Loaded);
  _updateWeather(res.data);
    }else {

          _setState(WeatherMapState.Error);

    //   _setError(res.statusCode)
    }
  }
  

double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


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

}
