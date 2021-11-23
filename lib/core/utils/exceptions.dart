// class LocationException implements Exception {
//   String cause;
//   LocationException(this.cause);
// }
// class AppException implements Exception {
//   final _message;
//   final _prefix;

//   AppException([this._message, this._prefix]);

//   String toString() {
//     return "$_prefix$_message";
//   }
// }

// class FetchDataException extends AppException {
//   FetchDataException([String message])
//       : super(message, "Error During Communication: ");
// }

// class BadRequestException extends AppException {
//   BadRequestException([message]) : super(message, "Invalid Request: ");
// }

// class UnauthorisedException extends AppException {
//   UnauthorisedException([message]) : super(message, "Unauthorised: ");
// }

// class InvalidInputException extends AppException {
//   InvalidInputException([String message]) : super(message, "Invalid Input: ");
// }
// class  NotFoundException extends AppException {
//   NotFoundException([message]) : super(message, " No data Found ");
// }
// class UnknownException extends AppException {
//   UnknownException([message]) : super(message, " Unknown Error , Try Again ");
// }
// class ServerException extends AppException {
//   ServerException([message]) : super(message, " Server  Error , Try Again ");
// }
// class ConnectionException extends AppException {
//   ConnectionException([message]) : super(message, " Check Your internet exception , Try Again ");
// }
