

import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/services/stream_sevices.dart';

class SocketService {
    io.Socket socket;

    SocketService(){
      createSocketConnection();
    }
  createSocketConnection() {
     socket = io.io('${LOCALSERVER}', {
      'transports': ['websocket'],
      'autoConnect': true,
    })
      ..on('connect', (_) {
 print('socket connected' +  socket.id);
        
      })..on('disconnect', (_) {});

    print(socket.id);
    print(socket.connected);
    //socket.off('active_bands');

    socket.emit('add_band', {'name': 'fluttertutorial'});
    socket.on('active_bands', _eventHandler);
    socket.on('ilikeit', (data) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(data);
      streamSocket.IlikeItResponse(data);
    });
    socket.on("likes", (data) {
      print('////////////////////////////////////');
      print(data);



                int data2 = int.parse(  (data["data"]).toString() );

      return streamSocket.likesResponse(data);
    });

     socket.on("location-comments", (data) {
     
      Iterable res = data;


      List<Comment> filters = res.map((type) {
        print("/////////////////");
        print(type.runtimeType);

        return Comment.fromJson(type);
      }).toList();

      return streamSocket.CommentsResponse(filters);
    });
  }


  void emit(String event , dynamic data){
    this.socket.emit(event , data);
  }

  void _eventHandler(Object object) {
    print(object);
  }




}