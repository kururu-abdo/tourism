import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/location_type.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/widgets/err_widget.dart';

class HomeViewModel extends BaseViewModel {
  API api = locator<API>();
  var translator = locator.get<TranslationServices>();
    StreamController<int>  _stream = new StreamController();
    Sink<int>  get sink => _stream.sink;
    Stream<int>  get stream => _stream.stream;
  bool isError = false;
  bool isLoading = false;
  List<TourismLocation> _locations = [];
  List<TourismLocation> get locations => _locations;
  AppException _error;
  AppException get exception => _error;
  List<LocationType> _types;
  List<LocationType> get types => _types;

  _setTypes(List<LocationType> types) {
    _types = types;
    notifyListeners();
  }

  _setError(AppException exception) {
    _error = exception;
    notifyListeners();
  }

  ViewState _state;

  ViewState get state => _state;

  _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void updateHome(List<TourismLocation> locations, isError, isLoading) {
    isLoading = isLoading;
    _setState(ViewState.Idle);
    isError = isError;
    locations = locations;

    notifyListeners();
  }

  _updateLocations(List<TourismLocation> locations) {
    _locations = locations;
    debugPrint(
        "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");

    debugPrint(_locations.length.toString());

    notifyListeners();
  }

  Future getLocations(int userId) async {
    _setState(ViewState.Busy);
    //posts = await _api.getPostsForUser(userId);
    _setState(ViewState.Idle);
  }

  ///TODO: get location types here
  getFitlters() async {
    _setState(ViewState.Busy);
    var result = await API.getAccomodations();

    if (!result.error) {
      _setState(ViewState.Idle);
      _setTypes(result.data);
    } else {
      _setState(ViewState.Error);
      _setError(getException(result.statusCode));
    }
  }

  Future<void> fetchLocations() async {
    _setState(ViewState.Busy);

    var fetchlocations = await API.fetchLocations();
    if (!fetchlocations.error) {
      _setState(ViewState.Idle);
      _updateLocations(fetchlocations.data);
    } else {
      _setState(ViewState.Error);
      _setError(getException(fetchlocations.statusCode));
      _updateLocations([]);
    }
  }

  Future<void> filterLocations(List types) async {
    print("----FILTER LOCATIONS ");
    _setState(ViewState.Busy);

    var fetchlocations = await API.filterLocations(types);
    if (!fetchlocations.error) {
      _setState(ViewState.Idle);

      _updateLocations(fetchlocations.data);
    } else {
      _setState(ViewState.Idle);

      _updateLocations([]);
      notifyListeners();
    }
  }

  Stream<int> getLocationLikes(int location) async* {
    var res = await API.getLocationLikes(location);
    if (!res.error) {
      yield  res.data;
    }
    yield  0;
  }

  addLike(user_id, location_id) async {
    var res = await API.addLike(user_id, location_id);
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
