import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/controllers/chat_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late ChatController controller;
  late MockSocketRepository mockSocketRepository;

  setUp(() {
    mockSocketRepository = MockSocketRepository();
    controller = ChatController(mockSocketRepository);
  });

  final tUrl = 'url';
  const tMessage = 'message';

  group('connect', () {
    test('connect should call socketRepository.connect and retrieve data',
        () async {
      // Arrange
      when(mockSocketRepository.connect(tUrl)).thenAnswer(
        (_) async => Right(null),
      );
      when(mockSocketRepository.receiveMessages()).thenAnswer(
        (_) => Stream.fromIterable([tMessage]),
      );
      // Act
      controller.connect(tUrl);
      // Assert
      await Future.delayed(const Duration(milliseconds: 100), () {
        expect(controller.message.value, tMessage);
      });
      verify(mockSocketRepository.connect(tUrl)).called(1);
      verify(mockSocketRepository.receiveMessages()).called(1);
    });
  });

  group('sendMessage', () {
    test('sendMessage should call socketRepository.sendMessage', () async {
      // Arrange
      when(mockSocketRepository.sendMessage(tMessage)).thenAnswer(
        (_) async => Right(null),
      );
      // Act
      controller.messageCtrl.text = tMessage;
      controller.sendMessage();
      // Assert
      verify(mockSocketRepository.sendMessage(tMessage)).called(1);
    });
  });

  group('disconnect', () {
    test('disconnect should call socketRepository.disconnect', () async {
      // Arrange
      when(mockSocketRepository.disconnect()).thenAnswer(
        (_) async => Right(null),
      );
      // Act
      controller.disconnect();
      // Assert
      verify(mockSocketRepository.disconnect()).called(1);
    });
  });

  group('dispose', () {
    test('dispose should call disconnect', () async {
      // Arrange
      when(mockSocketRepository.disconnect()).thenAnswer(
        (_) async => Right(null),
      );
      // Act
      controller.dispose();
      // Assert
      verify(mockSocketRepository.disconnect()).called(1);
    });
  });
}
