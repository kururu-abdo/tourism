import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class LoginViewModel extends BaseViewModel {
   AppException _error;
  AppException get exception => _error;
     var translator = locator.get<TranslationServices>();

 ViewState _state;
  ViewState get state => _state;

  _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
  User  _user;
  User  get user => _user;
  
  _setUser(User user){
    _user = user;
    
    notifyListeners();
  }
  _setError(AppException error) {
    _error = error;
    notifyListeners();
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