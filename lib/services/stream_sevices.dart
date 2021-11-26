import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tourapp/core/models/comment.dart';

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;



  final _socketLikesResponse = StreamController<Map>.broadcast();

  final _socketLikesResponse2= PublishSubject<int>();
  void Function(Map)   get likesResponse {
         Future<void>.delayed(Duration(milliseconds: 2));

    return _socketLikesResponse.sink.add;
  }

  Stream<Map> get getLikesResponse => _socketLikesResponse.stream.asBroadcastStream();
  
 

  final _socketIlikeItResponse2 = PublishSubject<int>();
  void Function(Map) get IlikeItResponse {
    Future<void>.delayed(Duration(milliseconds: 2));

    return _socketLikesResponse.sink.add;
  }

  Stream<Map> get getIlikeItResponse =>
      _socketLikesResponse.stream.asBroadcastStream();
  
 







  final _socketCommentsResponse = StreamController<List<Comment>>.broadcast();

  void Function(List<Comment>) get CommentsResponse => _socketCommentsResponse.sink.add;

  Stream<List<Comment>> get getCommentsResponse =>
      _socketCommentsResponse.stream;






  void dispose() {
    _socketResponse.close();
    _socketCommentsResponse.close();
    _socketLikesResponse.close();
    _socketLikesResponse2.close();
  }
}

StreamSocket streamSocket = StreamSocket();



