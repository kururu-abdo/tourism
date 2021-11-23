import 'package:tourapp/core/enums/http_call_status.dart';

class  APiRespnose<T> {
HttpCallStatus status;
T  data ;
bool error; 
String errorMessage ;
int statusCode;
  String message;

APiRespnose.loading(this.message) : status = HttpCallStatus.LOADING;
APiRespnose.completed(this.data) : status = HttpCallStatus.COMPLETED;
APiRespnose.error(this.message) : status = HttpCallStatus.ERROR;

@override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }


APiRespnose({this.data , this.error=false , this.errorMessage ,  this.statusCode});
}