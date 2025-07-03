import 'dart:async';
import 'dart:io';

import 'package:flutter_boilerplate/modules/socket/data/data_sources/remote/socket_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../helpers/test_helper.mocks.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {
  final StreamController<dynamic> _controller = StreamController<dynamic>();
  final MockWebSocketSink _sink = MockWebSocketSink();

  @override
  Stream<dynamic> get stream => _controller.stream;

  @override
  WebSocketSink get sink => _sink;

  void close() {
    _controller.close();
  }

  void add(dynamic data) {
    _controller.add(data);
  }
}

@GenerateMocks([WebSocketSink])
void main() {
  late SocketRemoteDataSource remoteDataSource;
  late MockWebSocketChannel mockWebSocketChannel;
  late MockSocketChannelFactory mockSocketChannelFactory;

  setUp(() {
    mockWebSocketChannel = MockWebSocketChannel();
    mockSocketChannelFactory = MockSocketChannelFactory();
    remoteDataSource = SocketRemoteDataSource(mockSocketChannelFactory);
  });

  tearDown(() {
    mockWebSocketChannel.close();
  });

  final tUrl = 'url';
  final tMessage = 'message';

  group('connect', () {
    test('should establish connection successfully', () async {
      // Arrange
      when(mockSocketChannelFactory.create(any))
          .thenReturn(mockWebSocketChannel);
      // Act
      await remoteDataSource.connect(tUrl);
      // Assert
      expect(remoteDataSource.isConnected(), true);
    });

    test('should throw WebSocketException when connection fails', () async {
      // Arrange
      when(mockSocketChannelFactory.create(any)).thenThrow(Exception());
      // Act
      final result = remoteDataSource.connect(tUrl);
      // Assert
      expect(() => result, throwsA(isA<WebSocketException>()));
    });
  });

  group('sendMessage', () {
    test('should send message through WebSocket channel', () async {
      // Arrange
      when(mockSocketChannelFactory.create(any))
          .thenReturn(mockWebSocketChannel);
      // Act
      await remoteDataSource.connect(tUrl);
      await remoteDataSource.sendMessage(tMessage);
      // Assert
      verify(mockWebSocketChannel.sink.add(tMessage));
    });

    test('should throw exception when not connected', () async {
      // Assert
      expect(() => remoteDataSource.sendMessage(tMessage),
          throwsA(isA<WebSocketException>()));
    });
  });

  group('messages', () {
    test('should emit parsed message when received through WebSocket',
        () async {
      // Arrange
      when(mockSocketChannelFactory.create(any))
          .thenReturn(mockWebSocketChannel);
      // Act
      await remoteDataSource.connect(tUrl);
      // Assert
      expectLater(remoteDataSource.messages, emits(isA<String>()));
      mockWebSocketChannel.add(tMessage);
    });

    test('should emit error when received invalid JSON', () async {
      // Arrange
      when(mockSocketChannelFactory.create(any))
          .thenReturn(mockWebSocketChannel);
      // Act
      remoteDataSource.connect(tUrl);
      // Assert
      expectLater(
        remoteDataSource.messages,
        emitsError(isA<WebSocketException>()),
      );
      mockWebSocketChannel.add(0);
    });
  });
}
