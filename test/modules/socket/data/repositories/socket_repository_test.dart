import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/socket/data/repository/socket_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SocketRepository repository;
  late MockSocketRemoteDataSource mockSocketRemoteDataSource;

  setUp(() {
    mockSocketRemoteDataSource = MockSocketRemoteDataSource();
    repository = SocketRepository(mockSocketRemoteDataSource);
  });

  final tUrl = 'url';
  final tMessage = 'message';

  group('connect', () {
    test('should return void when connection is successful', () async {
      // Arrange
      when(mockSocketRemoteDataSource.connect(tUrl))
          .thenAnswer((_) async => {});
      // Act
      final result = await repository.connect(tUrl);
      // Assert
      expect(result, equals(const Right(null)));
      verify(mockSocketRemoteDataSource.connect(tUrl));
      verifyNoMoreInteractions(mockSocketRemoteDataSource);
    });

    test('should return SocketFailure when connection fails', () async {
      // Arrange
      when(mockSocketRemoteDataSource.connect(tUrl))
          .thenThrow(WebSocketException('Connection failed'));
      // Act
      final result = await repository.connect(tUrl);
      // Assert
      expect(result, equals(Left(SocketFailure('Connection failed'))));
      verify(mockSocketRemoteDataSource.connect(tUrl));
      verifyNoMoreInteractions(mockSocketRemoteDataSource);
    });
  });

  group('sendMessage', () {
    test(
        'should call remote data source with correct data and return void on success',
        () async {
      // Arrange
      when(mockSocketRemoteDataSource.sendMessage(any))
          .thenAnswer((_) async => {});
      // Act
      final result = await repository.sendMessage(tMessage);
      // Assert
      expect(result, equals(const Right(null)));
      verify(mockSocketRemoteDataSource.sendMessage(tMessage));
      verifyNoMoreInteractions(mockSocketRemoteDataSource);
    });

    test('should return failure when remote data source throws', () async {
      // Arrange
      when(mockSocketRemoteDataSource.sendMessage(any))
          .thenThrow(WebSocketException('Send failed'));
      // Act
      final result = await repository.sendMessage(tMessage);
      // Assert
      expect(result, equals(Left(SocketFailure('Send failed'))));
      verify(mockSocketRemoteDataSource.sendMessage(tMessage));
      verifyNoMoreInteractions(mockSocketRemoteDataSource);
    });
  });

  group('receiveMessages', () {
    test('should return stream of messages from the remote data source', () {
      // Arrange
      when(mockSocketRemoteDataSource.messages)
          .thenAnswer((_) => Stream.fromIterable([tMessage]));
      // Act
      final resultStream = repository.receiveMessages();
      // Assert
      expect(resultStream, emitsInOrder([tMessage]));
      verify(mockSocketRemoteDataSource.messages);
      verifyNoMoreInteractions(mockSocketRemoteDataSource);
    });
  });
}
