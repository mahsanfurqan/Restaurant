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
  static String restaurantNamePlaceholder() => 'restaurantNamePlaceholder'.tr;
  static String menu() => 'menu'.tr;
  static String pengaturan() => 'pengaturan'.tr;

  static String passwordMinCharacterMessage(int min) =>
      'passwordMinCharacterMessage'.trParams({
        'min': min.toString(),
      });

  static String requestPermissionTitle(String appName, String permissionType) =>
      'permissionMessage'.trParams({
        'appName': appName,
        'permissionType': permissionType,
      });
}
