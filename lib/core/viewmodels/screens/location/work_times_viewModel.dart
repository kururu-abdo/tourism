import 'package:flutter/material.dart';
import 'package:tourapp/core/enums/work_times_state.dart';
import 'package:tourapp/core/models/work_time.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class WorkTimeViewModel extends BaseModel {
           var translator = locator.get<TranslationServices>();

WorkTimeState  _state;
WorkTimeState  get  widgetState =>_state;

List<WorkTime> _workTimes =[];
List<WorkTime> get workTimes => _workTimes;

AppException _exception;
AppException  get exception =>_exception;


_updateData(List<WorkTime> times) {
  _workTimes =times;
  notifyListeners();
}
_setState(WorkTimeState state) {
    _state = state;
    notifyListeners();
  }

  _setError(AppException error) {
    _exception = error;
    notifyListeners();
  }

fetchDate(int location_id)async{
_setState(WorkTimeState.Loading);
var res = await API.getWorkTimes(location_id);

if (!res.error) {

_updateData(res.data);

   _setState(WorkTimeState.Loaded);
}else{
  _setState(WorkTimeState.Error);

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