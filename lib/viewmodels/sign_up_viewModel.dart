import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/country.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';
import 'package:http/http.dart' as http;
class SignUpViewModel extends BaseViewModel {
       var translator = locator.get<TranslationServices>();

  List<Country> _countries = [];
    List<Country> get  countries =>_countries;
  AppException _error;
  AppException get exception => _error;
   ViewState  _state;
   ViewState get state => _state;



//SETTERS
   _setState(ViewState state){
     _state =state;
     notifyListeners();
   }
  _setError(AppException error) {
    _error = error;
    notifyListeners();
  }
  _setCountries (List<Country> countries){
    _countries = countries;
    notifyListeners();
  }


//methods

getCountries() async{
  _setState(ViewState.Busy);
  try {
      debugPrint("-------------make arequest" + API.url + "country/countries");
      var response = await http.get(Uri.parse(API.url + "country/countries"));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        Iterable I = json.decode(response.body)["data"];
        List<Country> countries = I.map((e) => Country.fromJson(e)).toList();

       _setState(ViewState.Idle);
       _setCountries(countries);
      }else {

            _setState(ViewState.Error);
        _setError(getError(800));
      }




    } on SocketException {
     _setState(ViewState.Error);
     _setError(getError(303));


    }
}







AppException getError(int code ){
return getException(code);
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