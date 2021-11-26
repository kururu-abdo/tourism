import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/models/company.dart';
import 'package:tourapp/core/models/current_weather_model.dart';
import 'package:tourapp/core/models/facilitate_loc.dart';
import 'package:tourapp/core/models/forecast_model.dart';
import 'package:tourapp/core/models/founded_locations.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/location_type.dart';
import 'package:tourapp/core/models/near_location.dart';
import 'package:tourapp/core/models/tag.dart';

import 'package:tourapp/core/models/tour_location.dart';
import 'package:tourapp/core/models/tourism_fac_loc.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/core/models/work_time.dart';
import 'package:tourapp/services/api_response.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/popular_filter_list.dart';
import 'package:http/http.dart' as http;

import 'api_helper.dart';
class API {

  //172.22.0.1
  //192.168.8.130
  //192.168.0.105
  //https://tour-app-sudan.herokuapp.com/
  static String  url = "https://tour-app-sudan.herokuapp.com/";
  

 //  sharedPrefs.getBaseUrl();
  // "http://192.168.8.163:8000/";

  static const image_url = "https://tour-app-sudan.herokuapp.com/";

  ApiBaseHelper _helper = ApiBaseHelper();

   var data = sharedPrefs.getBaseUrl();
 static  Future<APiRespnose<List<LocationType>>>  getAccomodations() async{
try {
      debugPrint("-------------make arequest" + API.url + "location/types");
   return  getUrl().then((value)async {
    
    
      var response = await http.get(
          Uri.parse(value + "location/types"),
        );
        if (response.statusCode == 200) {
          Iterable res = json.decode(response.body)['data'];

          debugPrint(response.body);

          List<LocationType> filters =
              res.map((type) => LocationType.fromJson(type)).toList();

          return APiRespnose<List<LocationType>>(data: filters);
        }

        debugPrint(response.body);
        return APiRespnose<List<LocationType>>(
            error: true, errorMessage: json.decode(response.body)["message"]);


    });

    } on SocketException {
      return
          APiRespnose<List<LocationType>>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }
  //get tags



 static Future<APiRespnose<List<Tag>>> getTags() async {
    try {
 return getUrl().then((value) async{
     debugPrint("-------------make arequest" + value + "location/tags");
        var response = await http.get(
          Uri.parse(API.url + "location/tags"),
        );
        if (response.statusCode == 200) {
          Iterable res = json.decode(response.body)['data'];

          debugPrint(response.body);

          List<Tag> filters = res.map((type) => Tag.fromJson(type)).toList();

          return APiRespnose<List<Tag>>(data: filters);
        }

        debugPrint(response.body);
        return APiRespnose<List<Tag>>(
            error: true, errorMessage: json.decode(response.body)["message"]);
 });
    } on SocketException {
      return APiRespnose<List<Tag>>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }









 static Future<APiRespnose<List<TourismLocation>>> fetchLocations() async {
    try {
      debugPrint("-------------make arequest" + API.url + "location/tour");
    return getUrl().then((value) async {

 var response = await http.get(
        Uri.parse(value + "location/tour"),
      ).timeout(new Duration(seconds: 15));
      if (response.statusCode == 200) {
        Iterable res = json.decode(response.body)['data'];

        debugPrint(response.body);

        List<TourismLocation> filters = res.map((type) => TourismLocation.fromJson(type)).toList();

        return APiRespnose<List<TourismLocation>>(data: filters);
      }
 if (response.statusCode == 500 || response.statusCode ==501||  response.statusCode ==503  ) {
    return APiRespnose<List<TourismLocation>>(
      statusCode:  500,
          error: true, errorMessage: json.decode(response.body)["message"]);
 }
      debugPrint(response.body);
      return APiRespnose<List<TourismLocation>>(
        statusCode: 403,
          error: true, errorMessage: json.decode(response.body)["message"]);

     }).catchError((err){
if(err is SocketException){
    return APiRespnose<List<TourismLocation>>(
              statusCode: 303,
              error: true,
              errorMessage: "تأكد من الاتصال بالانترنت");
} else if(err is TimeoutException){
   return APiRespnose<List<TourismLocation>>(
              statusCode: 302,
              error: true,
              errorMessage: "انتهت ملة الاتصال الخادم"); 
} else {
  
return APiRespnose<List<TourismLocation>>(
              statusCode: 800,
              error: true,
              errorMessage: "انتهت ملة الاتصال الخادم"); 
}


     });
   
   
   
   
   
    } on SocketException {
      return APiRespnose<List<TourismLocation>>(
        statusCode: 303 ,
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException{
       return APiRespnose<List<TourismLocation>>(
          statusCode: 302,
          error: true,
          errorMessage: "انتهت ملة الاتصال الخادم"); 
    } on FormatException{

return APiRespnose<List<TourismLocation>>(
          statusCode: 800,
          error: true,
          errorMessage: "انتهت ملة الاتصال الخادم"); 

    }
  }

 static Future<APiRespnose<List<TourismLocation>>> filterLocations(List types) async {
    try {
  return  getUrl().then((value) async{

  debugPrint("-------------make arequest" + API.url + "location/filter");
        var response = await http.get(
          Uri.parse(value + "location/filter?types=${json.encode(types)}"),
        );
        if (response.statusCode == 200) {
          Iterable res = json.decode(response.body)['data'];

          debugPrint(response.body);

          List<TourismLocation> filters =
              res.map((type) => TourismLocation.fromJson(type)).toList();

          return APiRespnose<List<TourismLocation>>(data: filters);
        }
        if (response.statusCode == 500 ||
            response.statusCode == 501 ||
            response.statusCode == 503) {
          return APiRespnose<List<TourismLocation>>(
              statusCode: 500,
              error: true,
              errorMessage: json.decode(response.body)["message"]);
        }
        debugPrint(response.body);
        return APiRespnose<List<TourismLocation>>(
            statusCode: 403,
            error: true,
            errorMessage: json.decode(response.body)["message"]);


    });
    } on SocketException {
      return APiRespnose<List<TourismLocation>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }

static Future<APiRespnose<List<TourismFacilitateLocation>>> faciltateLocations(
       int location_id , int type) async {
    try {
return getUrl().then((value) async{

      debugPrint("-------------make arequest" + API.url + "location/filter");
        var response = await http.get(
          Uri.parse(value +
              "location/facilitate?type=$type&location_id=$location_id"),
        );
        if (response.statusCode == 200) {
          Iterable res = json.decode(response.body)['data'];

          print(json.decode(response.body)['data'].runtimeType.toString());

          List<TourismFacilitateLocation> filters = res.map((type) {
            print("/////////////////");
            print(type.runtimeType);

            return TourismFacilitateLocation.fromJson(type);
          }).toList();

          return APiRespnose<List<TourismFacilitateLocation>>(data: filters);
        }
        if (response.statusCode == 500 ||
            response.statusCode == 501 ||
            response.statusCode == 503) {
          return APiRespnose<List<TourismFacilitateLocation>>(
              statusCode: 500,
              error: true,
              errorMessage: json.decode(response.body)["message"]);
        }
        debugPrint(response.body);
        return APiRespnose<List<TourismFacilitateLocation>>(
            statusCode: 403,
            error: true,
            errorMessage: json.decode(response.body)["message"]);
});
    } on SocketException {
      return APiRespnose<List<TourismFacilitateLocation>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }







static Future<APiRespnose<TourismLocation>>
      getLocation(int location_id) async {
    try {
    return getUrl().then((value) async{
  debugPrint("-------------make arequest" + API.url + "location/filter");
        var response = await http.get(
          Uri.parse(value + "location/get_location?id=$location_id"),
        );
        if (response.statusCode == 200) {
          print(response.body);
          Iterable res = json.decode(response.body)['data'];

          TourismLocation tourismFacilitateLocation =
              TourismLocation.fromJson(res.first);
          print(json.decode(response.body)['data'].runtimeType.toString());

          // List<TourismFacilitateLocation> filters = res.map((type) {
          //   print("/////////////////");
          //   print(type.runtimeType);

          //   return TourismFacilitateLocation.fromJson(type);
          // }).toList();

          return APiRespnose<TourismLocation>(data: tourismFacilitateLocation);
        }
        if (response.statusCode == 500 ||
            response.statusCode == 501 ||
            response.statusCode == 503) {
          return APiRespnose<TourismLocation>(
              statusCode: 500,
              error: true,
              errorMessage: json.decode(response.body)["message"]);
        }
        debugPrint(response.body);
        return APiRespnose<TourismLocation>(
            statusCode: 403,
            error: true,
            errorMessage: json.decode(response.body)["message"]);

    });
    } on SocketException {
      return APiRespnose<TourismLocation>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException{
 return APiRespnose<TourismLocation>(
          statusCode: 302,
          error: true,
          errorMessage: "ت");

    }
  }

static Future<APiRespnose<int>> getLocationLikes(int loceaation_id) async{
    try {
      debugPrint(
          "-------------make arequest" + API.url + "location/work_time/id");
   return getUrl().then((value) async{
   var response = await http.get(
          Uri.parse(value + "location/likes?id=$loceaation_id"),
        );
        if (response.statusCode == 200) {
          // Iterable res = json.decode(response.body)['data'];
          print(response.body);
          // print(json.decode(response.body)['data'].runtimeType.toString());
          int data = int.parse(json.decode(response.body)["data"].toString());

          return APiRespnose<int>(data: data);
        }
        if (response.statusCode == 500 ||
            response.statusCode == 501 ||
            response.statusCode == 503) {
          return APiRespnose<int>(
              statusCode: 500,
              error: true,
              errorMessage: json.decode(response.body)["message"]);
        }
        debugPrint(response.body);
        return APiRespnose<int>(
            statusCode: 403,
            error: true,
            errorMessage: json.decode(response.body)["message"]);


   });
   
   
       } on SocketException {
      return APiRespnose<int>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
}


static Future<APiRespnose<dynamic>>  addLike(user_id , location_id) async {
try {

      debugPrint("-------------make arequest" + API.url + "location/like");
  return   getUrl().then((value) async{

  var response = await http.post(
            Uri.parse(
             value + "location/like",
            ),
            headers: {"content-type": "application/json"},
            body: jsonEncode(<dynamic, dynamic>{
              "location_id": location_id,
              "user_id": user_id
            }));

        if (response.statusCode == 200) {
          APiRespnose<dynamic>(data: "you liked location");
        }

        return APiRespnose<dynamic>(
            error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");      

  });

} catch (e) {
   return APiRespnose<dynamic>(
          error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");      

}
}


static Future<APiRespnose<dynamic>> updateUser(String  name  , String phone , String address , int  country) async {
    try {
      debugPrint("-------------make arequest" + API.url + "location/like");
return getUrl().then((value)async {

      var response = await http.post(
          Uri.parse(
           value + "user/update",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(<dynamic, dynamic>{
            "id":  sharedPrefs.getUserID(),
            "name": name,
            "country_id": country ,
 "address": address,
            "phone": phone,



          }));

      if (response.statusCode == 200) {
        APiRespnose<dynamic>(data: "you liked location");
      }

      return APiRespnose<dynamic>(
          error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");


});
    } catch (e) {
      return APiRespnose<dynamic>(
          error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");
    }
  }



static Future<APiRespnose<dynamic>> resetPassword(user_id, String password) async {
    try {
      debugPrint("-------------make arequest" + API.url + "location/            API.url + location/reset_password");
      var response = await http.post(
          Uri.parse(
            API.url + "user/reset_password",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(<dynamic, dynamic>{
            "password": password,
            "id": user_id
          }));


          if(response.statusCode==200){
 return   APiRespnose<dynamic>(
     error: false,
     
     data: "password changed");
          }
else {
  
 return APiRespnose<dynamic>(
            error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");      


}


    } catch (e) {

 return  APiRespnose<dynamic> (error: true ,  statusCode: 800 ,  errorMessage: "خطأ غي متوقع ");      

    }
  }





static Future<APiRespnose<dynamic>> updatePhoto(String photo) async{


  try {
     var response = await http.post(
          Uri.parse(
            API.url + "user/update_image",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(
              <dynamic, dynamic>{"pic": photo, "id": sharedPrefs.getUserID()}))
              .timeout(new Duration(seconds: 20));
return APiRespnose(data:  response.body);

  } catch (e) {
     return APiRespnose<dynamic>(
          error: true, statusCode: 800, errorMessage: "خطأ غي متوقع ");      

  }
}






static Future<APiRespnose<List<WorkTime>>>
      getWorkTimes(int location_id) async {
    try {
      debugPrint("-------------make arequest" + API.url + "location/work_time/id");
      var response = await http.get(
        Uri.parse(API.url +
            "location/work_times/$location_id"),
      );
      if (response.statusCode == 200) {
        Iterable res = json.decode(response.body)['data'];

       debugPrint("---200 OK----");
        List<WorkTime> filters = res.map((type) {
       ;

          return WorkTime.fromJson(type);
        }).toList();

        return APiRespnose<List<WorkTime>>(data: filters);
      }
      if (response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 503) {
        return APiRespnose<List<WorkTime>>(
            statusCode: 500,
            error: true,
            errorMessage: json.decode(response.body)["message"]);
      }
      debugPrint(response.body);
      return APiRespnose<List<WorkTime>>(
          statusCode: 403,
          error: true,
          errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      return APiRespnose<List<WorkTime>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }




static Future<APiRespnose<List<FoundedLocations>>> search(
      String   str) async {
        print(sharedPrefs.getBaseUrl());
    try {
      debugPrint(
          "-------------SEARCH" + API.url + "location/work_time/id");
      var response = await http.get(
        Uri.parse(API.url + "location/search?loc=${str}"),
      );
      if (response.statusCode == 200) {
        Iterable res = json.decode(response.body)['data'];

        print(json.decode(response.body)['data'].runtimeType.toString());

        List<FoundedLocations> filters = res.map((type) {
          print("/////////////////");
          print(type.runtimeType);

          return FoundedLocations.fromJson(type);
        }).toList();

        return APiRespnose<List<FoundedLocations>>(data: filters);
      }
      if (response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 503) {
        return APiRespnose<List<FoundedLocations>>(
            statusCode: 500,
            error: true,
            errorMessage: json.decode(response.body)["message"]);
      }
      debugPrint(response.body);
      return APiRespnose<List<FoundedLocations>>(
          statusCode: 403,
          error: true,
          errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      return APiRespnose<List<FoundedLocations>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }
























static Future<APiRespnose<List<NearLocation>>> getNearPlace( LatLng  pos ,
      [double  range]) async {
    try {

      debugPrint(
          "-------------make arequest" + API.url + "location/work_time/id");
      var response = await http.get(
        Uri.parse(API.url+
         // "location/near?range=10&lat=15.5686772&lon=32.5779022"
         "location/near?lat=${pos.latitude}&lon=${pos.longitude}&range=${range??5.0}"
         
         
         ),
      );
      if (response.statusCode == 200) {
        Iterable res = json.decode(response.body)['data'];

        print(json.decode(response.body)['data']);

        List<NearLocation> filters = res.map((type) {
          print("/////////////////");
          print(type.runtimeType);

          return NearLocation.fromJson(type);
        }).toList();

        return APiRespnose<List<NearLocation>>(data: filters);
      }
      if (response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 503) {
        return APiRespnose<List<NearLocation>>(
            statusCode: 500,
            error: true,
            errorMessage: json.decode(response.body)["message"]);
      }
      debugPrint(response.body);
      return APiRespnose<List<NearLocation>>(
          statusCode: 403,
          error: true,
          errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      return APiRespnose<List<NearLocation>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }
static Future<APiRespnose<String>> addRating(
      int user, int location, double  rate) async {
    try {
      var response = await http.post(
          Uri.parse(
            API.url + "location/rank",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(<dynamic, dynamic>{
            "location_id": location,
            "user_id": user,
            "rate": rate
          }));
      if (response.statusCode == 200) {
        return APiRespnose<String>(statusCode: 200, data: "done");
      }
      return APiRespnose<String>(
          statusCode: 303,
          error: true,
          errorMessage: " حدث خطأ أثناء الاتصال بالسيرفر  ");
    } on SocketException {
      return APiRespnose<String>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }


static Future<APiRespnose<Map>>   getRating(int location_id) async {

try {
   var response = await http.get(
        Uri.parse(API.url + "location/rating?id=$location_id"),
      );

 if (response.statusCode == 200) {
debugPrint(response.body);
var data =  json.decode(response.body)['data'];
      return APiRespnose<Map>(data: data );
 


 }


 return APiRespnose<Map>(
          statusCode: 303,
          error: true,
          errorMessage: " حدثت مشكلة أثناء الاتصال بالسيرفر ");
      
}  on SocketException {
      return APiRespnose<Map>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }

}

static Future<APiRespnose<bool>> ckeckUserLike(int user  , int location)async{
try {
      var response = await http.get(
        Uri.parse(API.url + "location/ilikeit?id=$location&user_id=$user"),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        var result= int.parse(data.toString())==1?true:false;
        return APiRespnose<bool>(data: result);
      }

      return APiRespnose<bool>(
          statusCode: 303,
          error: true,
          errorMessage: " حدثت مشكلة أثناء الاتصال بالسيرفر ");
    } on SocketException {
      return APiRespnose<bool>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }

}
static Future<APiRespnose<String >> addComment( int user , int location  , String comment) async{

  try {
    
  var response = await http.post(
          Uri.parse(
            API.url + "location/comment",
          ),
          headers: {"content-type": "application/json"},
          body: jsonEncode(<dynamic, dynamic>{
            "location_id": location,
            "user_id": user ,
            "comment":comment

          }));
if(response.statusCode==200){
  return APiRespnose<String>(
          statusCode: 200,
data: "done"          
          );
  }
return APiRespnose<String>(
          statusCode: 303,
          error: true,
          errorMessage: " حدث خطأ أثناء الاتصال بالسيرفر  ");


  }      on SocketException {
 return APiRespnose<String>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
  }
}


static Future<APiRespnose<List<Comment>>> getComments(
      int location_id) async {
    try {
      debugPrint(
          "-------------make arequest" + API.url + "location/work_time/id");
      var response = await http.get(
        Uri.parse(API.url + "location/comments/$location_id"),
      );
      if (response.statusCode == 200) {
        Iterable res = json.decode(response.body)['data'];

        print(json.decode(response.body)['data'].runtimeType.toString());

        List<Comment> filters = res.map((type) {
          print("/////////////////");
          print(type.runtimeType);

          return Comment.fromJson(type);
        }).toList();

        return APiRespnose<List<Comment>>(data: filters);
      }
      if (response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 503) {
        return APiRespnose<List<Comment>>(
            statusCode: 500,
            error: true,
            errorMessage: json.decode(response.body)["message"]);
      }
      debugPrint(response.body);
      return APiRespnose<List<Comment>>(
          statusCode: 403,
          error: true,
          errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      return APiRespnose<List<Comment>>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }




static Future<String>  getUrl() async{
    // var response = await http.get(
    //   Uri.parse(
    //       "https://api.jsonstorage.net/v1/json/a0f018c1-ace1-4780-bc28-33faf9700066"),
    // );
    //  var res = json.decode(response.body);
    return "https://tour-app-sudan.herokuapp.com/";
    
   // res['my_url'];


}

static  Future<APiRespnose<String>> getAppBaseUrl() async {
//  try {
//       debugPrint("https://api.jsonstorage.net/v1/json/a0f018c1-ace1-4780-bc28-33faf9700066");
//       var response = await http.get(
//         Uri.parse(
//             "https://api.jsonstorage.net/v1/json/a0f018c1-ace1-4780-bc28-33faf9700066"),
//       );
//       if (response.statusCode == 200) {
//         var res = json.decode(response.body);

//         debugPrint(response.body);
//          sharedPrefs.SaveBaseUrl(res['my_url']);
//         return APiRespnose<String>(data: res['my_url']);
//       }
//       if (response.statusCode == 500 ||
//           response.statusCode == 501 ||
//           response.statusCode == 503) {
//         return APiRespnose<String>(
//             statusCode: 500,
//             error: true,
//             errorMessage: json.decode(response.body)["message"]);
//       }
//       debugPrint(response.body);
//       return APiRespnose<String>(
//           statusCode: 403,
//           error: true,
//           errorMessage: json.decode(response.body)["message"]);
//     } on SocketException {
//       return APiRespnose<String>(
//           statusCode: 303,
//           error: true,
//           errorMessage: "تأكد من الاتصال بالانترنت");
//     }


return APiRespnose<String>(data: "https://tour-app-sudan.herokuapp.com/");
}











 static Future<APiRespnose<CurrentWeatherResponse>> getCurrentWeatherInfo(LatLng position , String lang) async {
       try {
          String  url =
          'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=${WeatherMapApiKey}&lang=${lang}';

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds:20));
        if (response.statusCode==200) {
          debugPrint("CURRENT"+ response.body);
                final map = json.decode(response.body);
    CurrentWeatherResponse _foreCastWeatherResponse =
            CurrentWeatherResponse.fromJson(map);
      return APiRespnose<CurrentWeatherResponse>(data: _foreCastWeatherResponse );
  
        }
        else if(response.statusCode==500 ||  response.statusCode==501 ||  response.statusCode==503  ){
                  debugPrint("CURRENT" + response.body);

         return APiRespnose<CurrentWeatherResponse>(
            statusCode: 500,
            error: true,
            errorMessage: "خطأ في الخادم"); 
        }
        else if(response.statusCode==403){
   return APiRespnose<CurrentWeatherResponse>(
            statusCode: 403, error: true, errorMessage: " غير مصرح لك بالوصل إلى معلومات الطقس ");

        }

          debugPrint("CURRENT" + response.body);

   return APiRespnose<CurrentWeatherResponse>(
            statusCode: 800, error: true, errorMessage: "  لقد حدث خطأ    ");


      //print('temp: ${_currentWeatherResponse.main.temp}');
    }  on SocketException {
      return APiRespnose<CurrentWeatherResponse>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    }  on TimeoutException{
      
 return APiRespnose<CurrentWeatherResponse>(
          statusCode: 603,
          error: true,
          errorMessage: "إستغرق الاتصال وقتا طويلا");
      
    }
  }





















  static Future<APiRespnose<ForeCastWeatherResponse>> getForecastWeatherInfo(LatLng position) async {
      try {

          final url =
          'http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=${WeatherMapApiKey}';

      final response = await http.get(url);
      final map = json.decode(response.body);

  if (response.statusCode == 200) {
        final map = json.decode(response.body);
        debugPrint(response.body);
        ForeCastWeatherResponse _currentWeatherResponse =
            ForeCastWeatherResponse.fromJson(map);

        return APiRespnose<ForeCastWeatherResponse>(
            data: _currentWeatherResponse);
      } else if (response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 503) {
        return APiRespnose<ForeCastWeatherResponse>(
            statusCode: 500, error: true, errorMessage: "خطأ في الخادم");
      } else if (response.statusCode == 403) {
        return APiRespnose<ForeCastWeatherResponse>(
            statusCode: 403,
            error: true,
            errorMessage: " غير مصرح لك بالوصل إلى معلومات الطقس ");
      }

      return APiRespnose<ForeCastWeatherResponse>(
          statusCode: 800, error: true, errorMessage: "  لقد حدث خطأ    ");





      //print('temp: ${_currentWeatherResponse.main.temp}');
    } on SocketException {
      return APiRespnose<ForeCastWeatherResponse>(
          statusCode: 303,
          error: true,
          errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException {
      return APiRespnose<ForeCastWeatherResponse>(
          statusCode: 603,
          error: true,
          errorMessage: "إستغرق الاتصال وقتا طويلا");
    }
  }









//get user
static Future<APiRespnose<User>> fetch(int user) async {
    try {
      //  debugPrint("-------------make arequest" + SharedPrefs.intstance.getString("url"));
      //SharedPrefs.intstance.getString("url").trim()
      var response = await http
          .get(
            Uri.parse(API.url + "user/fetch?id=$user"),
          )
          .timeout(new Duration(seconds: 30));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        User user = User.fromJson(json.decode(response.body)["data"][0]);
        return APiRespnose<User>(data: user);
      }

      debugPrint(response.body);
      return APiRespnose<User>(
          error: true, errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      debugPrint("socket");
      return APiRespnose<User>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException {
      debugPrint("timeout");

      return APiRespnose<User>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }

//get user
  static Future<APiRespnose<List<Company>>> fetchCompanies() async {
    try {
      //  debugPrint("-------------make arequest" + SharedPrefs.intstance.getString("url"));
      //SharedPrefs.intstance.getString("url").trim()
      var response = await http
          .get(
            Uri.parse(API.url + "company/companies"),
          )
          .timeout(new Duration(seconds: 30));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        Iterable I = json.decode(response.body)["data"];
        List<Company>
        companies  =I.map((company) => Company.fromJson(company)).toList();
        
    
        return APiRespnose<List<Company>>(data: companies);
      }

      debugPrint(response.body);
      return APiRespnose<List<Company>>(
          error: true, errorMessage: json.decode(response.body)["message"]);
    } on SocketException {
      debugPrint("socket");
      return APiRespnose<List<Company>>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    } on TimeoutException {
      debugPrint("timeout");

      return APiRespnose<List<Company>>(
          error: true, errorMessage: "تأكد من الاتصال بالانترنت");
    }
  }

}