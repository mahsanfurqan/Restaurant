import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';

abstract class AppFakes {
  AppFakes._();

  static UserModel get user {
    return const UserModel(
      username: 'username',
      name: 'name',
    );
  }

  static NoteModel get note {
    return NoteModel(
      title: 'title',
      content: 'content',
      user: user,
    );
  }
}
