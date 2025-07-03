import 'package:flutter_boilerplate/core/common/network_info.dart';
import 'package:flutter_boilerplate/core/common/token_manager.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/services/auth_service.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/chat/presentation/controllers/chat_controller.dart';
import 'package:flutter_boilerplate/modules/home/presentation/controllers/home_controller.dart';
import 'package:flutter_boilerplate/modules/localization/data/data_sources/local/localization_local_data_source.dart';
import 'package:flutter_boilerplate/modules/localization/data/repositories/localization_repository.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/db/note_dao.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/note_local_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/note_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/services/note_service.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_detail_controller.dart';
import 'package:flutter_boilerplate/modules/note/presentation/controllers/note_form_controller.dart';
import 'package:flutter_boilerplate/modules/socket/data/data_sources/remote/socket_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/socket/data/repository/socket_repository.dart';
import 'package:flutter_boilerplate/modules/theme/data/data_source/local/theme_local_data_source.dart';
import 'package:flutter_boilerplate/modules/theme/data/repositories/theme_repository.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@GenerateMocks([
  // Controllers
  HomeController,
  NoteDetailController,
  NoteFormController,
  ChatController,

  // Repositories
  AuthRepository,
  NoteRepository,
  SocketRepository,
  LocalizationRepository,
  ThemeRepository,

  // Data Sources
  AuthRemoteDataSource,
  AuthLocalDataSource,
  UserRemoteDataSource,
  NoteRemoteDataSource,
  NoteLocalDataSource,
  SocketRemoteDataSource,
  LocalizationLocalDataSource,
  ThemeLocalDataSource,

  // Dao's
  UserDao,
  NoteDao,

  // Api Services
  AuthService,
  UserService,
  NoteService,

  // Others
  FlutterSecureStorage,
  TokenManager,
  NetworkInfo,
  SocketChannelFactory,
  WebSocketSink,
])
void main() {}
