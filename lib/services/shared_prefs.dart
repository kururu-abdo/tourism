import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/services/constants.dart';

class SharedPrefs {
  static  SharedPreferences _sharedPrefs;
   static  SharedPreferences get intstance => _sharedPrefs;
init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }
  Future<void> initializePreference() async {
   _sharedPrefs = await SharedPreferences.getInstance();
  }

//theme
  Future<String> getCurrentTheme() async {
    return _sharedPrefs.getString("theme") ?? "light";
  }

  Future<void> changeTheme(String theme) async {
    return _sharedPrefs.setString("theme", theme);
  }

//splah
 bool isShownBefore() {
    return _sharedPrefs.getBool("isshownbefore") ?? false;
  }
void changeShownBefore(bool value) async {
     _sharedPrefs.setBool("isshownbefore", value);
  }

//logedin

bool isLoggedIn() {
    return _sharedPrefs.getBool(ISLOGGEDIN) ?? false;
  }

    changeLoggedIn(bool value) async {
     _sharedPrefs.setBool(ISLOGGEDIN, value);
  }
//user


 saveUserName(String  value) async {
    _sharedPrefs.setString(USER_NAME, value);
  }
  String  getUserName() {
    return _sharedPrefs.getString(USER_NAME)??"" ;
  }


  
  saveUserIMage(String value) async {
    _sharedPrefs.setString(USER_IMAGE, value);
  }

  String getUserIMage() {
    return _sharedPrefs.getString(USER_IMAGE) ?? "";
  }

 saveUserID(int value) async {
    _sharedPrefs.setInt(USER_ID, value);
  }

  int  getUserID() {
    return _sharedPrefs.getInt(USER_ID) ?? "";
  }
  
 saveUserPassword(String value) async {
    _sharedPrefs.setString(USER_PASSWORD, value);
  }

  String getUserIMagePassword() {
    return _sharedPrefs.getString(USER_PASSWORD) ?? "";
  }


 saveFilterState(bool value) async {
    _sharedPrefs.setBool(ISCOMMINGFROMFILTER, value);
  }

  bool  getFilterState() {
    return _sharedPrefs.getBool(ISCOMMINGFROMFILTER) ?? false;
  }

   void saveUser(Map user){
     _sharedPrefs.setString('me', json.encode(user));
   }
   Map getUser(){
     print(_sharedPrefs.getString('me'));
     return json.decode( _sharedPrefs.getString('me'));
   }
   




//base url from cloud josn storage
//i face a peorblem that localhost cannot accessed by mobile device remotely

//so i use a service called ngrok
//this service allows you access localhost remotely
//with temporary url
//so every time run [ngrok htt 90000] it generate url
//and i copy it and save it the cloud json storage
//when app start i make http to get updated url in the storage

 SaveBaseUrl(String  value) async {
    return _sharedPrefs.setString(BASE_URL, value);
  }

String  getBaseUrl () {
    return _sharedPrefs.getString(BASE_URL) ?? false;
  }
}
final sharedPrefs = SharedPrefs();
