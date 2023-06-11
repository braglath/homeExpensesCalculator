import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeexpensecalculator/data/models/home_model.dart';
import 'package:homeexpensecalculator/data/storage/home_storage_operations.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_string.dart';

class RegistrationHomeSetupProvider extends ChangeNotifier {
  bool _isPageLoading = false;
  bool get isPageLoading => _isPageLoading;

  bool _isCardLoading = false;
  bool get isCardLoading => _isCardLoading;

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  String _homeCode = '';
  String get homeCode => _homeCode;

  String _encryptedKey = '';
  String get encryptedKey => _encryptedKey;

  bool _showSaveBtn = false;
  bool get showSaveBtn => _showSaveBtn;

  bool _showNextBtn = false;
  bool get showNextBtn => _showNextBtn;

  int? _createdHomeId;
  int? get createdHomeId => _createdHomeId;

  void setPageLoading(bool status) {
    _isPageLoading = status;
    notifyListeners();
  }

  void setCardLoading(bool status) {
    _isCardLoading = status;
    notifyListeners();
  }

  Future<void> setHomeCodeAndEncryption(String text) async {
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    setCardLoading(true);
    await Future<dynamic>.delayed(const Duration(milliseconds: 400));
    _encryptedKey = text.encrypt;
    _homeCode = text.random4String;
    await Clipboard.setData(const ClipboardData(text: "your text"));
    setShowNextBtn(true);
    setCardLoading(false);
  }

  void setShowNextBtn(bool status) => _showNextBtn = status;

  void setShowSaveBtn(bool status) {
    _showSaveBtn = status;
    notifyListeners();
  }

  Future<void> navigateTo(PageController pageController, int i) async {
    await pageController.animateToPage(i,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
    _currentPageIndex = i;
    notifyListeners();
  }

  Future<void> addOrUpdateHome({
    required HomeModel home,
    required PageController pageController,
    required int i,
  }) async {
    int? homeId;
    if (_createdHomeId == null) {
      homeId = await HomeStorageOperations.addHome(home);
    } else {
      homeId = await HomeStorageOperations.updateHome(home);
    }
    if (homeId == null) return;
    _createdHomeId = homeId;
    await pageController.animateToPage(i,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
    _currentPageIndex = i;
    notifyListeners();
  }
}
