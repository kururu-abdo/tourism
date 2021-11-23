import 'package:flutter/material.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

enum CommentViewState { Loading, Loaded, Error }

class CommentViewModel extends ChangeNotifier {
  var translator = locator.get<TranslationServices>();
  CommentViewState _state;
  CommentViewState get state => _state;
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  double _rating = 0.0;
  double get rating => _rating;
  bool _iLikeIt;
bool get iLikeIt => _iLikeIt;


_updtaeCheckLike(bool res){
  _iLikeIt= res;
  notifyListeners();
}

  AppException _error;
  AppException get error => _error;

_setError(AppException error) {
  _error=error;
  notifyListeners();
}


  _setState(CommentViewState state) {
    _state = state;
    notifyListeners();
  }

  _updateComments(List<Comment> comments) {
    _comments = comments;
    notifyListeners();
  }

  _updateRating(double rate) {
    _rating = rate;
    notifyListeners();
  }

  getRatings(int location_id) async {
    var rates = await API.getRating(location_id);
    if (!rates.error) {
      _setState(CommentViewState.Loaded);

      var total = double.parse(rates.data['total'].toString());

      var total_users = double.parse(rates.data['total_users'].toString());
      if (total > 0) {

        if(total_users ==1){
                  _updateRating(total);

        }
        print("oooooooooooooooooooooooooooooooooo");
        print((total / total_users).round().toDouble());
        _updateRating(   (total / total_users).round().toDouble()   );
      }

      _updateRating(0.0);
    } else {
            _setState(CommentViewState.Loaded);

      _updateRating(0.0);
    }
  }
 ilikeIt(int location  ,  int user) async{
var check =await API.ckeckUserLike(user, location);
if(!check.error){
  _setState(CommentViewState.Loaded);
  _updtaeCheckLike(check.data);
}else {
  _updtaeCheckLike(false);
}
}
  fetchData(int location_id) async {
    _setState(CommentViewState.Loading);
    var commetns = await API.getComments(location_id);

    if (!commetns.error) {
      _setState(CommentViewState.Loaded);
      _updateComments(commetns.data);
    } else {
      _setState(CommentViewState.Error);
      var error =  checkError(commetns.statusCode);
      _setError(error);
    }
  }

addComment(int user  , int location ,  String comment)async {
    _setState(CommentViewState.Loading);
var add = await API.addComment(user, location, comment);

if (
  !add.error
) {
      _setState(CommentViewState.Loaded);
      await fetchData(location);
} else {
      _setState(CommentViewState.Error);
      checkError(add.statusCode);

}



}

addCommentRating(int user, int location, double  rate) async {
    _setState(CommentViewState.Loading);
    var add = await API.addRating (user, location, rate );

    if (!add.error) {
      _setState(CommentViewState.Loaded);
      await fetchData(location);
    } else {
      _setState(CommentViewState.Error);
      checkError(add.statusCode);
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
        return ConnectionException(
            "Check your internet exception");
        break;
      default:
        return UnknownException("Unknown Exception ");
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
