import 'dart:async';
import 'dart:developer';
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
      log('SocketService: Cannot connect, no access token found.');
      return;
    }

    log('SocketService: Connecting to socket server...');
    
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
      log('SocketService: Connected successfully');
    });

    _socket!.onDisconnect((_) {
      log('SocketService: Disconnected');
    });

    _socket!.onConnectError((err) {
      log('SocketService: Connection error: $err');
    });

    _socket!.onError((err) {
      log('SocketService: Error: $err');
    });

    // Listen for the new camelCase queue updates
    _socket!.on('queueUpdate', (data) {
      log('SocketService: Received queueUpdate: $data');
      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });

    // Keep generic queue updates as fallback
    _socket!.on('queue_update', (data) {
      log('SocketService: Received queue_update: $data');
      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });

    // Listen for specialized serving updates
    _socket!.on('serving_updated', (data) {
      log('SocketService: Received serving_updated: $data');
      if (data is Map<String, dynamic>) {
        _updateController.add(data);
      }
    });
  }

  void joinHospitalRoom(String hospitalId) {
    if (_socket == null || !_socket!.connected) {
      connect();
    }
    log('SocketService: Joining hospital room: $hospitalId');
    _socket?.emit('join_hospital', hospitalId);
  }

  void leaveHospitalRoom(String hospitalId) {
    log('SocketService: Leaving hospital room: $hospitalId');
    _socket?.emit('leave_hospital', hospitalId);
  }

  void disconnect() {
    log('SocketService: Disconnecting manually...');
    _socket?.disconnect();
    _socket = null;
  }

  @disposeMethod
  void dispose() {
    disconnect();
    _updateController.close();
  }
}
