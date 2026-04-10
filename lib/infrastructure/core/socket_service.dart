import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:qflow/domain/auth/app_session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@lazySingleton
class SocketService {
  final AppSession _session;
  IO.Socket? _socket;
  final _updateController = StreamController<Map<String, dynamic>>.broadcast();

  SocketService(this._session);

  Stream<Map<String, dynamic>> get updates => _updateController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket != null && _socket!.connected) return;

    final token = _session.accessToken;
    if (token == null) {
      return;
    }


    
    // Using the base domain from the network module
    _socket = IO.io('https://backend.devforchange.com', 
      IO.OptionBuilder()
        .setTransports(['websocket']) // Restricting to websocket only
        .setAuth({'token': token})
        .enableForceNew() // Ensure a clean connection
        .enableAutoConnect()
        .build()
    );

    _socket!.onConnect((_) {
    });


    _socket!.onDisconnect((_) {
    });


    _socket!.onConnectError((err) {
    });


    _socket!.onError((err) {
    });


    // Listen for the new camelCase queue updates
    _socket!.on('queueUpdate', (data) {

      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });

    // Keep generic queue updates as fallback
    _socket!.on('queue_update', (data) {

      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });

    // Listen for specialized serving updates
    _socket!.on('serving_updated', (data) {

      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });
  }

  void joinHospitalRoom(String hospitalId) {
    if (_socket == null || !_socket!.connected) {
      connect();
    }

    _socket?.emit('join_hospital', hospitalId);
  }

  void leaveHospitalRoom(String hospitalId) {

    _socket?.emit('leave_hospital', hospitalId);
  }

  void disconnect() {

    _socket?.disconnect();
    _socket = null;
  }

  @disposeMethod
  void dispose() {
    disconnect();
    _updateController.close();
  }
}
