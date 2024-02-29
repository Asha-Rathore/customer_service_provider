import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart';

import '../service_navigation/socket_navigation_class.dart';
import '../utils/app_dialogs.dart';
import '../utils/network_strings.dart';

class SocketService {
  static Socket? _socket;

  SocketService._();

  static SocketService? _instance;

  static SocketService? get instance {
    if (_instance == null) {
      _instance = SocketService._();
    }
    return _instance;
  }

  Socket? get socket => _socket;

  void initializeSocket() {
    _socket = io(NetworkStrings.SOCKET_BASE_URL, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
  }

  void connectSocket() {
    // _socket = io(NetworkStrings.SOCKET_API_BASE_URL, <String, dynamic>{
    //   'autoConnect': false,
    //   'transports': ['websocket'],
    // });

    _socket?.connect();

    _socket?.on("connect", (data) {
        // AppDialogs.showToast(message: 'Connected socket $data');
      log('Connected socket ');
      // checkSocketConnection(true);
    });

    _socket?.on("disconnect", (data) {
      // AppDialogs.showToast(message: 'Disconnected socket $data');
      log('Disconnected ' + data.toString());
    });

    _socket?.on("connect_error", (data) {
      log('Connect Error ' + data.toString());
    });

    _socket?.on("error", (data) {
      log('Error ' + data.toString());
      SocketNavigationClass.instance?.socketErrorMethod(errorResponseData: data);
    });

    log("Socket Connect:${socket?.connected}");
  }

  void socketEmitMethod(
      {required String eventName, required dynamic eventParamaters,bool? emitFromStatusScreen=false}) {
    _socket?.emit(eventName, eventParamaters);

  }

  void socketResponseMethod() {
    _socket?.on("response", (data) {
      SocketNavigationClass.instance?.socketResponseMethod(
          responseData: data);
    });
  }

  void dispose() {
    _socket?.dispose();
  }
}