import 'package:get_it/get_it.dart';
import 'package:tourapp/core/services/dialog_services.dart';
import 'package:tourapp/core/services/translation_services.dart';
import 'package:tourapp/core/viewmodels/screens/home/home_viewmodel.dart';
import 'package:tourapp/core/viewmodels/screens/location/location_details_viewmodel.dart';
import 'package:tourapp/core/viewmodels/screens/location/resttunrant_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/work_times_viewModel.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/DBhelper.dart';
import 'package:tourapp/services/location_services.dart';
import 'package:tourapp/viewmodels/signup_viewmodel.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';

import 'core/viewmodels/screens/location/hotel_view_model.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
//services and providers
  locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() =>LocationServiceProvider());
    locator.registerLazySingleton(() =>SignUpProvider());
    locator.registerLazySingleton(() =>DBHelper.db);

    locator.registerLazySingleton(() => TranslationServices());



//viewmodels
locator.registerFactory(() => HomeViewModel());
locator.registerFactory(() => SignupViewModel());
locator.registerFactory(() => TripViewModel());
locator.registerFactory(() => LocationDetailsViewModel());
locator.registerFactory(() => ResturnatViewModel());
locator.registerFactory(() => WorkTimeViewModel());
locator.registerFactory(() => HotelViewModel());

locator.registerLazySingleton(() => DialogService());



}
