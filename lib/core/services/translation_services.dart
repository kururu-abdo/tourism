import 'package:flutter_translator/flutter_translator.dart';
import 'package:tourapp/ui/shared/app.dart';

class TranslationServices {


  final TranslatorGenerator translator = TranslatorGenerator.instance;
  String getCurrentLang() {
    return translator.currentLocale.languageCode;
  }

  String getString(String key) {
    return translator.getString(App.navigatorKey.currentContext, key);
  }


}