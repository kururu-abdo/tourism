import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/viewmodels/screens/base_viewmodel.dart';

class HomeViewModel extends BaseModel {
  String title = 'default';

  void initialise() {
    title = 'initialised';
    notifyListeners();
  }

  int counter = 0;
  void updateTitle() {
    counter++;
    title = '$counter';
    notifyListeners();
  }
}
