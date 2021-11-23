import 'package:flutter/material.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:tourapp/ui/shared/app.dart';

class TranslationProvider extends ChangeNotifier{
final TranslatorGenerator translator = TranslatorGenerator.instance;
String getCurrentLang(){
return translator.currentLocale.languageCode;
}
String getString(String key){
return translator.getString(App.navigatorKey.currentContext, key);
}




}