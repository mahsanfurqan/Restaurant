abstract class AppAssets {
  AppAssets._();

  static final AppImages _images = AppImages._();
  static AppImages get images => _images;

  static final AppPngIcons _pngIcons = AppPngIcons._();
  static AppPngIcons get pngIcons => _pngIcons;
}

class AppImages {
  AppImages._();

  String get idFlag => 'assets/images/id_flag.png';
  String get enFlag => 'assets/images/en_flag.png';
  String get nasiGoreng => 'assets/images/nasigoreng.jpg';
  String get matcha => 'assets/images/matcha.jpg';
  String get load => 'assets/images/load.jpg';
}

class AppPngIcons {
  AppPngIcons._();

  String get light => 'assets/icons/ic_light.png';
  String get dark => 'assets/icons/ic_dark.png';
}
