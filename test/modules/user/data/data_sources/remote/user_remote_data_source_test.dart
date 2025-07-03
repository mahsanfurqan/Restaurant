import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../dummy_data/dummy_objects.dart';
import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late UserRemoteDataSource dataSource;
  late MockUserService mockApiService;

  setUp(() {
    mockApiService = MockUserService();
    dataSource = UserRemoteDataSource(
      mockApiService,
    );
  });

  group('getUserById', () {
    const testId = 1;

    test('should return user with given id when success', () async {
      // Arrange
      when(mockApiService.getUserById(testId)).thenAnswer(
        (_) async => BaseResponse(data: tUserModel),
      );
      // Act
      final result = await dataSource.getUserById(testId);
      // Assert
      expect(result, BaseResponse(data: tUserModel));
    });
  });
}
