import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/modules/menu/data/repositories/menu_repository.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';

class ViewMenuController extends GetxController {
  final MenuRepository _repository;

  ViewMenuController(this._repository);

  final _menuState =
      Rx<ResultState<List<MenuModel>>>(const ResultState.initial());
  final _isOfflineMode = false.obs;
  final _hasCachedData = false.obs;

  // Getters
  ResultState<List<MenuModel>> get menuState => _menuState.value;
  bool get isOfflineMode => _isOfflineMode.value;
  bool get hasCachedData => _hasCachedData.value;

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    _menuState.value = const ResultState.loading();

    final result = await _repository.fetchMenus();

    result.fold(
      (failure) {
        _checkCachedData().then((hasCache) {
          if (hasCache) {
            _isOfflineMode.value = true;
            _hasCachedData.value = true;
            _loadCachedMenus();
          } else {
            _isOfflineMode.value = false;
            _hasCachedData.value = false;
            final message = AppUtils.getErrorMessage(failure.error?.errors);
            _menuState.value =
                ResultState.failed(message ?? 'Gagal memuat menu');
          }
        });
      },
      (menus) {
        _isOfflineMode.value = false;
        _hasCachedData.value = false;
        _menuState.value = ResultState.success(menus);
      },
    );
  }

  Future<void> refreshMenu() async {
    final result = await _repository.refreshMenus();

    result.fold(
      (failure) {
        _checkCachedData().then((hasCache) {
          if (hasCache) {
            _isOfflineMode.value = true;
            _hasCachedData.value = true;
            _loadCachedMenus();
          } else {
            _isOfflineMode.value = false;
            _hasCachedData.value = false;
            final message = AppUtils.getErrorMessage(failure.error?.errors);
            _menuState.value =
                ResultState.failed(message ?? 'Gagal memuat menu');
          }
        });
      },
      (menus) {
        _isOfflineMode.value = false;
        _hasCachedData.value = false;
        _menuState.value = ResultState.success(menus);
      },
    );
  }

  Future<bool> _checkCachedData() async {
    return await _repository.hasCachedData();
  }

  Future<void> _loadCachedMenus() async {
    final result = await _repository.fetchMenus();
    result.fold(
      (failure) {
        _menuState.value = ResultState.failed('Tidak ada data tersimpan');
      },
      (menus) {
        _menuState.value = ResultState.success(menus);
      },
    );
  }

  Future<void> loadCachedMenus() async {
    await _loadCachedMenus();
  }

  Future<bool> deleteMenu(int id) async {
    final result = await _repository.deleteMenu(id);
    return result.isRight();
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
    _hasCachedData.value = false;
  }

  bool get isCurrentlyOffline => _isOfflineMode.value;
  bool get hasCachedDataAvailable => _hasCachedData.value;
}
