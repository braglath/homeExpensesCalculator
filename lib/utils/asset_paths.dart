class AssetPaths {
  AssetPaths._instance();
  factory AssetPaths() => _singleton;
  static final AssetPaths _singleton = AssetPaths._instance();

  static String get homeSetup => 'assets/images/home_setup.jpg';
  static String get logo => 'assets/images/logo.png';
}
