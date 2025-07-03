import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/common/network_info.dart';
import 'package:flutter_boilerplate/core/common/token_manager.dart';
import 'package:flutter_boilerplate/core/services/api_client.dart';
import 'package:flutter_boilerplate/core/services/app_database.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/auth/data/data_sources/remote/services/auth_service.dart';
import 'package:flutter_boilerplate/modules/auth/data/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/connectivity/presentation/controllers/connectivity_controller.dart';
import 'package:flutter_boilerplate/modules/localization/data/data_sources/local/localization_local_data_source.dart';
import 'package:flutter_boilerplate/modules/localization/data/repositories/localization_repository.dart';
import 'package:flutter_boilerplate/modules/localization/presentation/controllers/localization_controller.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/db/note_dao.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/note_local_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/note_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/remote/services/note_service.dart';
import 'package:flutter_boilerplate/modules/note/data/repositories/note_repository.dart';
import 'package:flutter_boilerplate/modules/socket/data/data_sources/remote/socket_remote_data_source.dart';
import 'package:flutter_boilerplate/modules/socket/data/repository/socket_repository.dart';
import 'package:flutter_boilerplate/modules/theme/data/data_source/local/theme_local_data_source.dart';
import 'package:flutter_boilerplate/modules/theme/data/repositories/theme_repository.dart';
import 'package:flutter_boilerplate/modules/theme/presentation/controllers/theme_controller.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/services/user_service.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:flutter_boilerplate/shared/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AppBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final baseUrl = AppConstants.general.baseUrl;
    final appDatabase = await $FloorAppDatabase
        .databaseBuilder(AppConstants.general.appDatabase)
        .build();

    // Externals
    Get.lazyPut<Dio>(() => ApiClient.getDio(baseUrl));
    Get.lazyPut<AndroidOptions>(
        () => const AndroidOptions(encryptedSharedPreferences: true));
    Get.lazyPut<FlutterSecureStorage>(
        () => FlutterSecureStorage(aOptions: Get.find()));
    Get.lazyPut<Connectivity>(() => Connectivity());
    Get.lazyPut<ImagePicker>(() => ImagePicker());
    Get.lazyPut<DeviceInfoPlugin>(() => DeviceInfoPlugin());

    // Helpers
    Get.lazyPut<NetworkInfo>(() => NetworkInfo(Get.find()));
    Get.lazyPut<TokenManager>(() => TokenManager());
    Get.lazyPut<SocketChannelFactory>(() => SocketChannelFactory());

    // Dao's
    Get.lazyPut<UserDao>(() => appDatabase.userDao);
    Get.lazyPut<NoteDao>(() => appDatabase.noteDao);

    // Api Services
    Get.lazyPut<AuthService>(() => AuthService(Get.find()));
    Get.lazyPut<UserService>(() => UserService(Get.find()));
    Get.lazyPut<NoteService>(() => NoteService(Get.find()));

    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSource(Get.find()));
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource(Get.find()));
    Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSource(Get.find()));
    Get.lazyPut<NoteRemoteDataSource>(() => NoteRemoteDataSource(Get.find()));
    Get.lazyPut<NoteLocalDataSource>(
        () => NoteLocalDataSource(Get.find(), Get.find()));
    Get.lazyPut<SocketRemoteDataSource>(
        () => SocketRemoteDataSource(Get.find()));
    Get.lazyPut<LocalizationLocalDataSource>(
        () => LocalizationLocalDataSource(Get.find()));
    Get.lazyPut<ThemeLocalDataSource>(() => ThemeLocalDataSource(Get.find()));

    // Repositories
    Get.put<AuthRepository>(
        AuthRepository(Get.find(), Get.find(), Get.find(), Get.find()));
    Get.put<NoteRepository>(NoteRepository(Get.find(), Get.find()));
    Get.put<SocketRepository>(SocketRepository(Get.find()));
    Get.put<LocalizationRepository>(LocalizationRepository(Get.find()));
    Get.put<ThemeRepository>(ThemeRepository(Get.find()));

    // Controllers
    Get.put<AuthController>(AuthController(Get.find()));
    Get.put<ConnectivityController>(ConnectivityController(Get.find()));
    Get.put<ThemeController>(ThemeController(Get.find()));
    Get.put<LocalizationController>(LocalizationController(Get.find()));
  }
}
