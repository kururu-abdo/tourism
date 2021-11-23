import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/company.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class CompanyViewModel extends BaseViewModel {
         var translator = locator.get<TranslationServices>();
  AppException _error;
  AppException get exception => _error;
    ViewState _state;
    ViewState get state => _state;
  List<Company> _companies =[];
  List<Company> get companies => _companies;
    void _updateState(ViewState state){
      _state =state;
      notifyListeners();
    }
    _updateData(List<Company> comp){
      _companies=  comp;
      notifyListeners();
    }
_setError(AppException exception) {
    _error = exception;
    notifyListeners();
  }
fetchCompanies() async{
  _updateState(ViewState.Busy);
  var data = await API.fetchCompanies();
if(!data.error){
  _updateState(ViewState.Idle);
  _updateData(data.data);

}else {
  _updateState(ViewState.Error);
      _setError(getException(data.statusCode));
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