import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/common/failures.dart';
import 'package:flutter_boilerplate/modules/socket/data/data_sources/remote/socket_remote_data_source.dart';

class SocketRepository {
  final SocketRemoteDataSource _remoteDataSource;

  const SocketRepository(this._remoteDataSource);

  bool isConnected() => _remoteDataSource.isConnected();

  Future<Either<Failure, void>> connect(String url) async {
    try {
      await _remoteDataSource.connect(url);
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(SocketFailure(e.message));
    }
  }

  Future<Either<Failure, void>> disconnect() async {
    try {
      await _remoteDataSource.disconnect();
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(SocketFailure(e.message));
    }
  }

  Future<Either<Failure, void>> sendMessage(String message) async {
    try {
      await _remoteDataSource.sendMessage(message);
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(SocketFailure(e.message));
    }
  }

  Stream<String> receiveMessages() {
    return _remoteDataSource.messages;
  }
}
