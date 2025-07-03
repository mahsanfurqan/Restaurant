import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketChannelFactory {
  WebSocketChannel create(String url) {
    return WebSocketChannel.connect(Uri.parse(url));
  }
}

class SocketRemoteDataSource {
  final SocketChannelFactory _channelFactory;

  SocketRemoteDataSource(this._channelFactory);

  WebSocketChannel? _channel;
  bool _isConnected = false;

  final StreamController<String> _messagesCtrl =
      StreamController<String>.broadcast();

  bool isConnected() => _isConnected;

  Stream<String> get messages => _messagesCtrl.stream;

  Future<void> connect(String url) async {
    try {
      if (_isConnected) return;

      _channel = _channelFactory.create(url);
      _isConnected = true;

      _channel!.stream.listen(
        (message) {
          try {
            _messagesCtrl.add(message);
          } catch (e) {
            _messagesCtrl.addError(
              WebSocketException('Failed to parse message: $e'),
            );
          }
        },
        onError: (error) {
          _isConnected = false;
          _messagesCtrl.addError(
            WebSocketException('WebSocket error: $error'),
          );
        },
        onDone: () {
          _isConnected = false;
          // _messagesCtrl.close(); // Tidak menutup controller agar dapat digunakan kembali
        },
      );
    } catch (e) {
      _isConnected = false;
      throw WebSocketException('Failed to connect to WebSocket: $e');
    }
  }

  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close();
      _isConnected = false;
    }
    _messagesCtrl.close();
  }

  Future<void> sendMessage(String message) async {
    if (!_isConnected || _channel == null) {
      throw WebSocketException('WebSocket is not connected');
    }

    try {
      _channel!.sink.add(message);
    } catch (e) {
      throw WebSocketException('Failed to send message: $e');
    }
  }
}
