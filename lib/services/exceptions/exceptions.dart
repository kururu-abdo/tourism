class LocationException implements Exception {
  String cause;
  LocationException(this.cause);
}
class AppException implements Exception {
  final _message;


  AppException([this._message]);

  String toString() {
    return "$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message);
}
class NotFoundException extends AppException {
  NotFoundException([message]) : super(message);
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message);
}

class UnknownException extends AppException {
  UnknownException([String message]) : super(message);
}


class ServerException extends AppException {
  ServerException([message]) : super(message);
}

class ConnectionException extends AppException {
  ConnectionException([message])
      : super(message);
}
class MyTimeoutConnection extends AppException {
  MyTimeoutConnection([message])
      : super(message);
}
