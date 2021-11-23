import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tourapp/core/models/country.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/shared_prefs.dart';

class SignUpProvider extends ChangeNotifier {
  Future<APiRespnose<List<Country>>> getCountries() async {
    try {
      debugPrint("-------------make arequest" + API.url + "country/countries");
      var response = await http.get(Uri.parse(API.url + "country/countries"));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        Iterable I = json.decode(response.body)["data"];
        List<Country> countries = I.map((e) => Country.fromJson(e)).toList();

        return APiRespnose<List<Country>>(data: countries);
      }

      debugPrint(response.body);
      return APiRespnose<List<Country>>(
          error: true, errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      return APiRespnose<List<Country>>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }









Future<APiRespnose<bool>>  newUser(User   user ) async {
    try {
      debugPrint("-------------make arequest" + API.url + "user/signup");
var body =   <String  ,  dynamic >  {

    "user_name": user.userName,
        "email": user.email,
        "phone": user.phone,
        "password": user.password,
        "address": user.address,
        "country_id": user.country.countryId.toString(),
        "userTypeTypeId": 1.toString() ,
      "pic" :  user.pic??""
};


      var response = await http.post(Uri.parse(API.url + "user/signup") ,
      headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
      
      body: jsonEncode(body)
      
      );

      if (response.statusCode == 200) {
        

        return APiRespnose<bool>(data: true);
      } else if( response.statusCode==404 ){
return APiRespnose<bool>(
            statusCode: 404,
            error: true,
            errorMessage: NoData404);
      }

      debugPrint(response.body);
      return APiRespnose<bool>(
        statusCode: 808,
          error: true, errorMessage: UNKNOWN);
    } on SocketException {
      return APiRespnose<bool>(
        statusCode: 303,
          error: true, errorMessage: NOINTERNET);
    }  on TimeoutException{

return APiRespnose<bool>(
          statusCode: 303,
          error: true,
          errorMessage: TIMEOUT);

    }
  }

Future<APiRespnose<User>> login(String phone ,  String password) async {
    try {
    //  debugPrint("-------------make arequest" + SharedPrefs.intstance.getString("url"));
      //SharedPrefs.intstance.getString("url").trim()
      var response = await http.get(
        Uri.parse(API.url + "user/login?phone=$phone&password=$password"),
         ).timeout(new Duration(seconds: 30));
         

      if (response.statusCode == 200) {
  
        debugPrint(response.body);
        User user =  User.fromJson(json.decode(response.body)["data"][0]);
        return APiRespnose<User>(data: user);
      }

      debugPrint(response.body);
      return APiRespnose<User>(
        statusCode: 404,
          error: true, errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
       debugPrint("socket");
      return APiRespnose<User>(
          statusCode: 303,
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException{
                 debugPrint("timeout");

      return APiRespnose<User>(
        statusCode: 302,
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }

  }


}
