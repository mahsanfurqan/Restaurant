import 'package:get/get.dart';

abstract class AppLocalizations {
  AppLocalizations._();

  static String selectFromGallery() => 'selectFromGallery'.tr;
  static String openCamera() => 'openCamera'.tr;
  static String uploadPhoto() => 'uploadPhoto'.tr;
  static String uploadVideo() => 'uploadVideo'.tr;
  static String gallery() => 'gallery'.tr;
  static String camera() => 'camera'.tr;
  static String microphone() => 'microphone'.tr;
  static String cancel() => 'cancel'.tr;
  static String openSetting() => 'openSetting'.tr;
  static String permissionMessage() => 'permissionMessage'.tr;
  static String notesTitle() => 'notesTitle'.tr;
  static String note() => 'note'.tr;
  static String createNote() => 'createNote'.tr;
  static String editNote() => 'editNote'.tr;
  static String username() => 'username'.tr;
  static String password() => 'password'.tr;
  static String usernamePlaceholder() => 'usernamePlaceholder'.tr;
  static String passwordPlaceholder() => 'passwordPlaceholder'.tr;
  static String login() => 'login'.tr;
  static String loginSubtitle() => 'loginSubtitle'.tr;
  static String save() => 'save'.tr;
  static String usernameRequiredMessage() => 'usernameRequiredMessage'.tr;
  static String passwordRequiredMessage() => 'passwordRequiredMessage'.tr;
  static String passwordUpperCaseMessage() => 'passwordUpperCaseMessage'.tr;
  static String passwordLowerCaseMessage() => 'passwordLowerCaseMessage'.tr;
  static String passwordNumberMessage() => 'passwordNumberMessage'.tr;
  static String passwordSpecialCharacterMessage() =>
      'passwordSpecialCharacterMessage'.tr;
  static String passwordNotMatchMessage() => 'passwordNotMatchMessage'.tr;
  static String loading() => 'loading'.tr;
  static String refreshing() => 'refreshing'.tr;
  static String pullToRefresh() => 'pullToRefresh'.tr;
  static String releaseToRefresh() => 'releaseToRefresh'.tr;
  static String refreshCompleted() => 'refreshCompleted'.tr;
  static String refreshFailed() => 'refreshFailed'.tr;
  static String pullToLoadMore() => 'pullToLoadMore'.tr;
  static String releaseToLoadMore() => 'releaseToLoadMore'.tr;
  static String loadFailed() => 'loadFailed'.tr;
  static String networkErrorTitle() => 'networkErrorTitle'.tr;
  static String networkErrorMessage() => 'networkErrorMessage'.tr;
  static String yes() => 'yes'.tr;
  static String logoutTitle() => 'logoutTitle'.tr;
  static String logoutMessage() => 'logoutMessage'.tr;
  static String successTitle() => 'successTitle'.tr;
  static String createNoteSuccessMessage() => 'createNoteSuccessMessage'.tr;
  static String ok() => 'ok'.tr;
  static String emptyNotesMessage() => 'emptyNotesMessage'.tr;
  static String unexpectedErrorMessage() => 'unexpectedErrorMessage'.tr;
  static String confirm() => 'confirm'.tr;
  static String info() => 'info'.tr;
  static String warning() => 'warning'.tr;
  static String error() => 'error'.tr;
  static String success() => 'success'.tr;
  static String title() => 'title'.tr;
  static String titlePlaceholder() => 'titlePlaceholder'.tr;
  static String notePlaceholder() => 'notePlaceholder'.tr;
  static String titleRequiredMessage() => 'titleRequiredMessage'.tr;
  static String noteRequiredMessage() => 'noteRequiredMessage'.tr;
  static String deleteNote() => 'deleteNote'.tr;
  static String deleteNoteConfirmationMessage() =>
      'deleteNoteConfirmationMessage'.tr;
  static String deleteNoteSuccessMessage() => 'deleteNoteSuccessMessage'.tr;
  static String loggingOut() => 'loggingOut'.tr;
  static String home() => 'home'.tr;
  static String settings() => 'settings'.tr;
  static String preferences() => 'preferences'.tr;
  static String language() => 'language'.tr;
  static String displayMode() => 'displayMode'.tr;
  static String system() => 'system'.tr;
  static String systemModeDesc() => 'systemModeDesc'.tr;
  static String lightMode() => 'lightMode'.tr;
  static String lightModeDesc() => 'lightModeDesc'.tr;
  static String darkMode() => 'darkMode'.tr;
  static String darkModeDesc() => 'darkModeDesc'.tr;
  static String account() => 'account'.tr;
  static String logout() => 'logout'.tr;
  static String chat() => 'chat'.tr;
  static String messagePlaceholder() => 'messagePlaceholder'.tr;
  static String send() => 'send'.tr;
  static String dontHaveAccount() => 'dontHaveAccount'.tr;
  static String register() => 'register'.tr;
  static String alreadyHaveAccount() => 'alreadyHaveAccount'.tr;
  static String loginAction() => 'loginAction'.tr;
  static String fullName() => 'fullName'.tr;
  static String fullNamePlaceholder() => 'fullNamePlaceholder'.tr;
  static String restaurantName() => 'restaurantName'.tr;
  static String restaurantAddress() => 'restaurantAddress'.tr;
  static String restaurantDescription() => 'restaurantDescription'.tr;
  static String restaurantPhone() => 'restaurantPhone'.tr;
  static String restaurantNamePlaceholder() => 'restaurantNamePlaceholder'.tr;
  static String restaurantAddressPlaceholder() =>
      'restaurantAddressPlaceholder'.tr;
  static String restaurantDescriptionPlaceholder() =>
      'restaurantDescriptionPlaceholder'.tr;
  static String restaurantPhonePlaceholder() => 'restaurantPhonePlaceholder'.tr;
  static String menu() => 'menu'.tr;
  static String pengaturan() => 'pengaturan'.tr;
  static String addMenu() => 'addMenu'.tr;
  static String menuName() => 'menuName'.tr;
  static String menuNameRequired() => 'menuNameRequired'.tr;
  static String category() => 'category'.tr;
  static String categoryRequired() => 'categoryRequired'.tr;
  static String descriptionOptional() => 'descriptionOptional'.tr;
  static String price() => 'price'.tr;
  static String priceRequired() => 'priceRequired'.tr;
  static String priceMustBeNumber() => 'priceMustBeNumber'.tr;
  static String imageRequired() => 'imageRequired'.tr;
  static String categoryFood() => 'categoryFood'.tr;
  static String categoryDrink() => 'categoryDrink'.tr;
  static String menuNasiGoreng() => 'menuNasiGoreng'.tr;
  static String menuMatcha() => 'menuMatcha'.tr;
  static String description() => 'description'.tr;

  static String passwordMinCharacterMessage(int min) =>
      'passwordMinCharacterMessage'.trParams({
        'min': min.toString(),
      });

  static String requestPermissionTitle(String appName, String permissionType) =>
      'permissionMessage'.trParams({
        'appName': appName,
        'permissionType': permissionType,
      });

  static String settingsTitle() => 'settingsTitle'.tr;
  static String preferencesTitle() => 'preferencesTitle'.tr;
  static String themeTitle() => 'themeTitle'.tr;
  static String themeSubtitle() => 'themeSubtitle'.tr;
  static String languageTitle() => 'languageTitle'.tr;
  static String languageSubtitle() => 'languageSubtitle'.tr;
  static String accountTitle() => 'accountTitle'.tr;
  static String restaurantSettingTitle() => 'restaurantSettingTitle'.tr;
  static String restaurantSettingSubtitle() => 'restaurantSettingSubtitle'.tr;
  static String bahasaIndonesia() => 'bahasaIndonesia'.tr;
  static String english() => 'english'.tr;
  static String lihatMenuTitle() => 'lihatMenuTitle'.tr;
  static String descNasiGoreng() => 'descNasiGoreng'.tr;
  static String descMatcha() => 'descMatcha'.tr;
  static String edit() => 'edit'.tr;
  static String deleteMenu() => 'deleteMenu'.tr;
  static String deleteMenuConfirmation() => 'deleteMenuConfirmation'.tr;
  static String deleteMenuSuccess() => 'deleteMenuSuccess'.tr;
  static String deleteMenuFailed() => 'deleteMenuFailed'.tr;
  static String editMenu() => 'editMenu'.tr;
  static String menuNameLabel() => 'menuNameLabel'.tr;
  static String categoryLabel() => 'categoryLabel'.tr;
  static String priceLabel() => 'priceLabel'.tr;
  static String descriptionLabel() => 'descriptionLabel'.tr;
  static String menuNotFound() => 'menuNotFound'.tr;
  static String errorOccurred() => 'errorOccurred'.tr;
  static String editMenuSuccess() => 'editMenuSuccess'.tr;
  static String editMenuFailed() => 'editMenuFailed'.tr;
  static String email() => 'email'.tr;
  static String emailPlaceholder() => 'emailPlaceholder'.tr;
  static String emailRequiredMessage() => 'emailRequiredMessage'.tr;
  static String emailInvalidMessage() => 'emailInvalidMessage'.tr;
  static String registerUsername() => 'registerUsername'.tr;
  static String registerUsernamePlaceholder() =>
      'registerUsernamePlaceholder'.tr;
  static String registerUsernameRequiredMessage() =>
      'registerUsernameRequiredMessage'.tr;
  static String createMenuSuccessMessage() => 'createMenuSuccessMessage'.tr;
  static String logoutSuccess() => 'logoutSuccess'.tr;
  static String logoutFailed() => 'logoutFailed'.tr;
  static String retry() => 'retry'.tr;
}
