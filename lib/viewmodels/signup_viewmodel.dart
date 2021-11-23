import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:tourapp/core/models/country.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/api_response.dart';

class SignupViewModel  extends ChangeNotifier{

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
}