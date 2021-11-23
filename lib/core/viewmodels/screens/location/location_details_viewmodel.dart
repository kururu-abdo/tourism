import 'package:flutter/cupertino.dart';
import 'package:tourapp/core/enums/LocationDetails_states.dart';
import 'package:tourapp/core/enums/tabs.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/tourism_fac_loc.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';
class LocationDetailsViewModel extends ChangeNotifier {
         var translator = locator.get<TranslationServices>();

LocationDetailsState  _state;
LocationDetailsState  get state=>_state;

_setState(LocationDetailsState state){
  _state =  state;
  notifyListeners();
}
TourismLocation _location;
TourismLocation get location  => _location;
 AppException _error;
  AppException get exception => _error;
  _setError(AppException error) {
    _error = error;
    notifyListeners();
  }

_setLocation(TourismLocation location){
  _location = location;
  notifyListeners();
}

  int index =0;
List<Comment> comments =[];
double rating=0.0;
int likes = 0;
SelectedTab  _tab = SelectedTab.ABOUT;
SelectedTab get tab =>_tab;


  changeIndex(int i){
    
       index =i;
      _tab = SelectedTab.values[index];
 notifyListeners();
  }


getLocationDetials( int location)async{
_setState(LocationDetailsState.Loading);

var data = await API.getLocation(location);
if (!data.error) {
  _setState(LocationDetailsState.Loaded);
  _setLocation(data.data);
} else {
  _setState(LocationDetailsState.Error);

   _setError(getError(data.statusCode));
}
}

AppException getError(int code) {
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