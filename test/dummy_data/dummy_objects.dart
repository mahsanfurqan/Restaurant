import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/login_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/logout_dto.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/token_model.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/entities/note_entity.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_dto.dart';
import 'package:flutter_boilerplate/modules/note/data/models/note_model.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';
import 'package:flutter_boilerplate/modules/user/data/models/user_model.dart';
import 'package:flutter_boilerplate/shared/responses/base_error_response.dart';
import 'package:flutter_boilerplate/shared/responses/base_response.dart';
import 'package:flutter_boilerplate/shared/responses/error_detail_response.dart';
import 'package:flutter_boilerplate/shared/responses/meta_response.dart';

const tTokenJson = {
  'refreshToken': 'refreshToken',
  'accessToken': 'accessToken',
};

const tTokenModel = TokenModel(
  refreshToken: 'refreshToken',
  accessToken: 'accessToken',
);

const tLoginDtoJson = {
  'username': 'username',
  'password': 'password',
};

const tLoginDto = LoginDto(
  username: 'username',
  password: 'password',
);

const tLogoutDtoJson = {
  'refreshToken': 'refreshToken',
};

const tLogoutDto = LogoutDto(
  refreshToken: 'refreshToken',
);

const tUserJson = {
  'id': 1,
  'username': 'username',
  'name': 'name',
};

const tUserModel = UserModel(
  id: 1,
  username: 'username',
  name: 'name',
);

final tUserModels = [tUserModel];

const tUserEntity = UserEntity(
  id: 1,
  username: 'username',
  name: 'name',
);

final tUserEntities = [tUserEntity];

const tMetaJson = {
  'page': 1,
  'totalData': 1,
  'totalPage': 1,
};

const tMetaResponse = MetaResponse(
  page: 1,
  totalData: 1,
  totalPage: 1,
);

const tErrorDetailJson = {
  'detail': 'detail',
  'attr': 'attr',
};

const tErrorDetailResponse = ErrorDetailResponse(
  detail: 'detail',
  attr: 'attr',
);

const tBaseErrorJson = {
  'type': 'type',
  'errors': [tErrorDetailJson],
};

const tBaseErrorResponse = BaseErrorResponse(
  type: 'type',
  errors: [tErrorDetailResponse],
);

final tBaseJson = {
  'meta': tMetaJson,
  'data': [tUserJson],
};

const tBaseResponse = BaseResponse<List<UserModel>>(
  meta: tMetaResponse,
  data: [tUserModel],
);

const tAuthValidateJson = {
  'id': 1,
  'username': 'username',
  'hasGroups': [],
  'hasPermissions': [],
};

const tAuthValidateModel = AuthValidateModel(
  id: 1,
  username: 'username',
  hasGroups: [],
  hasPermissions: [],
);

final tNoteJson = {
  'id': 1,
  'title': 'title',
  'content': 'content',
  'createdAt': DateTime(2025, 1, 1).toIso8601String(),
  'updatedAt': DateTime(2025, 1, 1).toIso8601String(),
  'user': tUserJson,
};

final tNoteModel = NoteModel(
  id: 1,
  title: 'title',
  content: 'content',
  createdAt: DateTime(2025, 1, 1),
  updatedAt: DateTime(2025, 1, 1),
  user: tUserModel,
);

final tNoteModels = [tNoteModel];

final tNoteEntity = NoteEntity(
  id: 1,
  title: 'title',
  content: 'content',
  userId: 1,
  createdAt: DateTime(2025, 1, 1).toIso8601String(),
  updatedAt: DateTime(2025, 1, 1).toIso8601String(),
);

final tNoteEntities = [tNoteEntity];

const tNoteDtoJson = {
  'title': 'title',
  'content': 'content',
};

const tNoteDto = NoteDto(
  title: 'title',
  content: 'content',
);
