import 'package:flutter/material.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class UserViewmodel extends ChangeNotifier{
  AppException _exception;
  AppException get exception => _exception;
         var translator = locator.get<TranslationServices>();

  User _user;
  User get user =>  _user;

WidgetState _state;
  WidgetState get widgetState => _state;

  _setUser(User user) {
    _user = user;
    notifyListeners();
  }


_setState(WidgetState state) {
    _state = state;
    notifyListeners();
  }

  _setError(AppException error) {
    _exception = error;
    notifyListeners();
  }


  getUserById(int user) async{
    _setState(WidgetState.Loading);
    var res =  await API.fetch(user);

    if(!res.error){
          _setState(WidgetState.Loaded);

      _setUser(res.data);
    }else{
    _setState(WidgetState.Error);
checkError(res.statusCode);
    }


  }




void checkError(int code) {
    switch (code) {
      case 500:
        _setError(ServerException());
        break;

      case 303:
        _setError(ConnectionException());
        break;
      case 404:
        _setError(NotFoundException());
        break;
      default:
        _setError(UnknownException());
    }
  }
resetPassword(String  newPassword) async{
    _setState(WidgetState.Loading);
  var result = await API.resetPassword(sharedPrefs.getUserID(), newPassword);
  if(!result.error){
    _setState(WidgetState.Loaded);

  }else {
    print(result.statusCode);
    _setState(WidgetState.Error);
  checkError(result.statusCode);
  }

}


updateUser(String name  , String phone , String address , int Country     )async{
  _setState(WidgetState.Loading);
  var result = await API.updateUser(name, phone, address, Country);
  if (!result.error) {
    _setState(WidgetState.Loaded);

  }else {
    _setState(WidgetState.Error);
  checkError(result.statusCode);
  }

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