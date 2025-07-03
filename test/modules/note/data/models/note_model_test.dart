import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../dummy_data/dummy_objects.dart';

void main() {
  test('should return a valid model from JSON', () async {
    // Arrange
    final Map<String, dynamic> jsonMap = tNoteJson;
    // Act
    final result = NoteModel.fromJson(jsonMap);
    // Assert
    expect(result, tNoteModel);
  });

  test('should return a valid model from entity', () async {
    // Arrange
    final noteEntity = tNoteEntity;
    const userEntity = tUserEntity;
    // Act
    final result = NoteModel.fromEntity(noteEntity, user: userEntity);
    // Assert
    expect(result, tNoteModel);
  });

  test('should return a JSON map containing proper data', () async {
    // Act
    final result = tNoteModel.toJson();
    // Assert
    final expectedJsonMap = tNoteJson;
    expect(result, expectedJsonMap);
  });

  test('should return a Entity containing proper data', () async {
    // Act
    final result = tNoteModel.toEntity();
    // Assert
    expect(result, tNoteEntity);
  });
}
