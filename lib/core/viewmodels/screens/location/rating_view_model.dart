import 'package:flutter/material.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class RatingViewmodel extends ChangeNotifier {
         var translator = locator.get<TranslationServices>();

WidgetState _state;
  WidgetState get widgetState => _state;
double _rating=0.0;
double get rating => _rating;


_updateRating(double rate){
  _rating =rate;
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
 AppException _exception;
  AppException get exception => _exception;



addRating(int user, int location, double rate) async {
    _setState(WidgetState.Loading);
    var add = await API.addRating(user, location, rate);

    if (!add.error) {
      _setState(WidgetState.Loaded);
      await getRatings(location);
    } else {
      _setState(WidgetState.Error);
      checkError(add.statusCode);
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






  getRatings(int location_id) async {
    var rates = await API.getRating(location_id);
    if (!rates.error) {
      _setState(WidgetState.Loaded);

      var total = double.parse(rates.data['total'].toString());

      var total_users = double.parse(rates.data['total_users'].toString());
      if (total > 0) {
        if (total_users == 1) {
          _updateRating(total);
        }
        print("oooooooooooooooooooooooooooooooooo");
        print((total / total_users).round().toDouble());
        _updateRating((total / total_users).round().toDouble());
      }else{
         _updateRating(0.0);
      }
  
    //  _updateRating(0.0);
    } else {
      _setState(WidgetState.Loaded);

      _updateRating(0.0);
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












  @override
  void dispose() {
    _setState(WidgetState.Loaded);
    // TODO: implement dispose
    super.dispose();
  }

}