import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tourapp/core/utils/constants.dart';

class LikesSocketServices {
  
  createSocketConnection() {
    var socket = io.io('${LOCALSERVER}' +'location', {
      'transports': ['websocket'],
      'autoConnect': true,
    })
      ..on('connect', (_) {



      })..on('disconnect', (_) {});

    print(socket.id);
    print(socket.connected);
    //socket.off('active_bands');

    socket.emit('like', {'name': 'fluttertutorial'});
    socket.on('likes', _eventHandler);
  }




  void _eventHandler(Object object) {
    print(object);
  }
}