import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/enums/work_times_state.dart';
import 'package:tourapp/core/models/near_location.dart';
import 'package:tourapp/core/models/work_time.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

import '../../../../locator.dart';

class NearViewmdel extends BaseModel {
           var translator = locator.get<TranslationServices>();

  WidgetState _state;
  WidgetState get widgetState => _state;

  List<NearLocation> _nears = [];
  List<NearLocation> get nears => _nears;

  AppException _exception;
  AppException get exception => _exception;

  _updateData(List<NearLocation> nears) {
    _nears = nears;
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

  initial(LatLng pos , [double range]) async {
    _setState(WidgetState.Loading);
    var res = await API.getNearPlace(pos , range??10.0);

    if (!res.error) {
      _updateData(res.data);

      _setState(WidgetState.Loaded);
    } else {
      _setState(WidgetState.Error);

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
