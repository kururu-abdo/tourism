import 'package:flutter/cupertino.dart';
import 'package:tourapp/core/enums/LocationDetails_states.dart';
import 'package:tourapp/core/enums/hotel_state.dart';
import 'package:tourapp/core/enums/tabs.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/models/tourism_fac_loc.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/views/location/hotels.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class HotelViewModel extends BaseModel {
  HotelState _state;
  HotelState get widgettate => _state;
List<TourismFacilitateLocation> _locations = [];
         var translator = locator.get<TranslationServices>();

  List<TourismFacilitateLocation> get locations => _locations;
AppException _exception;
  AppException get error => _exception;
_setState(HotelState state) {
    _state = state;
    notifyListeners();
  }

  _setError(AppException error) {
    _exception = error;
    notifyListeners();
  }

_updateLocations(List<TourismFacilitateLocation> locs) {
    _locations = locs;
    notifyListeners();
  }


fetchData(int location_id) async{
_setState(HotelState.Loading);

    var res = await API.faciltateLocations(location_id, 1);

    if (!res.error) {
      _updateLocations(res.data);

      _setState(HotelState.Loaded);
    } else {
      _setState(HotelState.Error);

      checkError(res.statusCode);
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



}
