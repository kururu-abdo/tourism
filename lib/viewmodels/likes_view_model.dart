import 'package:stacked/stacked.dart';

class FutureExampleViewModel extends FutureViewModel<int> {
  Future<int> getLikes () async {
    await Future.delayed(const Duration(seconds: 3));
    throw Exception('This is an error');
  }

  @override
  void onError(error) {
    // error thrown above will be sent here
    // We can show a dialog, set the error message to show on the UI
    // the UI will be rebuilt after this is called so you can set properties.
  }

  @override
  Future<int> futureToRun() => getLikes();
}
