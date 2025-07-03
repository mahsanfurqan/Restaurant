import 'package:flutter_test/flutter_test.dart';

import '../../../../dummy_data/dummy_objects.dart';

void main() {
  test('should return a JSON map containing proper data', () async {
    // Act
    final result = tLogoutDto.toJson();
    // Assert
    const expectedJsonMap = tLogoutDtoJson;
    expect(result, expectedJsonMap);
  });
}
