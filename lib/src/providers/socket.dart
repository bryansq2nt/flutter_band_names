
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

enum ServerStatus { Online, Offline, Connecting }
class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get status => _serverStatus;
  IO.Socket get socket => _socket;


  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    this._socket = IO.io('http://192.168.0.16:4000/',{
      'transports':['websocket'],
      'autoConnect': true
    });


    socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();

    });

    socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });



  }

}