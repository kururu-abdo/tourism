import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';
enum  LikeState{Loading  , Loaded  , Error}
class  LikeViewModel extends BaseViewModel{
           var translator = locator.get<TranslationServices>();

  LikeState _state;
  LikeState get widgetState => _state;
int _likes=0;
 int get likes =>_likes; 

  bool _iLikeIt;
  bool get iLikeIt => _iLikeIt;

  static get locator => null;

_updtaeCheckLike(bool res) {
    _iLikeIt = res;
    notifyListeners();
  }
_updateLikes(int likes){
  _likes =likes;
  notifyListeners();
}
  AppException _error;
  AppException get exception  => _error;

  _setError(AppException error) {
    _error = error;
    notifyListeners();
  }
   _setState(LikeState state) {
    _state = state;
    notifyListeners();
  }


 ilikeIt(int location, int user) async {
    var check = await API.ckeckUserLike(user, location);
    if (!check.error) {
      _setState(LikeState.Loaded);
      _updtaeCheckLike(check.data);
    } else {
      _updtaeCheckLike(false);
      _setState(LikeState.Error);
      _setError(getException(check.statusCode));

    }
  }



Future<int> getLocationLikes(int location) async {
    _setState(LikeState.Loading);

 
    var res = await API.getLocationLikes(location);
  
    if (!res.error) {
          _setState(LikeState.Loaded);
 _likes=  res.data;
 notifyListeners();

       _updateLikes(res.data);
       
      return res.data;
    }
        _setState(LikeState.Loaded);
 _likes = res.data;
    notifyListeners();
           _updateLikes(0);

    return 0;
  }

addLike(user_id , location_id)async{
      _setState(LikeState.Loading);

var res = await API.addLike(user_id, location_id);
if (!res.error) {
      _setState(LikeState.Loaded);

}else{
 _setState(LikeState.Error);
_setError(getException(res.statusCode));
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