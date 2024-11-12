import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';

class HomeProvider extends ChangeNotifier
    with IronSourceImpressionDataListener, IronSourceInitializationListener {

  bool _isFromHomeScreen = true;

  bool get isFromHomeScreen => _isFromHomeScreen;

  void setFromHomeScreen(bool value) {
    _isFromHomeScreen = value;
    notifyListeners();
  }

  bool _isTutorialShowing = false;

  bool get isTutorialShowing => _isTutorialShowing;

  void setTutorialShowing(bool value) {
    _isTutorialShowing = value;
    notifyListeners();
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;

  setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  PageController get pageController => _pageController;

  HomeProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initIronSource();
    });
  }

  Future<void> checkATT() async {
    final currentStatus =
        await ATTrackingManager.getTrackingAuthorizationStatus();
    debugPrint('ATTStatus: $currentStatus');
    if (currentStatus == ATTStatus.NotDetermined) {
      final returnedStatus =
          await ATTrackingManager.requestTrackingAuthorization();
      debugPrint('ATTStatus returned: $returnedStatus');
    }
    return;
  }

  /// To validate ironSource Ad integration and enable debug logs
  Future<void> enableDebug() async {
    await IronSource.setAdaptersDebug(true);
    IronSource.validateIntegration();
  }

  Future<void> setRegulationParams() async {
    await IronSource.setConsent(true);
    await IronSource.setMetaData({
      'do_not_sell': ['false'],
      'is_child_directed': ['false'],
      'is_test_suite': ['enable']
    });
    return;
  }

  Future<void> initIronSource() async {
    final appKey = Platform.isAndroid
        ? "152b3cbe9"
        : Platform.isIOS
            ? "152b4b209"
            : throw Exception("Unsupported Platform");
    try {
      IronSource.setFlutterVersion('3.19.3');
      IronSource.setImpressionDataListener(this);

      /// Uncomment below code if needed for testing
      // await enableDebug();
      await IronSource.shouldTrackNetworkState(true);

      /// Uncomment below code if needed
      // await setRegulationParams();
      String id = await IronSource.getAdvertiserId();
      debugPrint('AdvertiserID: $id');
      await IronSource.setUserId(
          "UserID-${PreferenceHelper.get(PrefUtils.userRegistrationNumber)}${PreferenceHelper.get(PrefUtils.userPhoneNumber)}");

      /// Uncomment below code if needed - for now this block creating issue that's why commented it.
      // if (Platform.isIOS) {
      //   await checkATT();
      // }
      await IronSource.init(
        appKey: appKey,
        adUnits: [IronSourceAdUnit.Interstitial],
        initListener: this,
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void navigateToPremium() {
    onItemTapped(3);
  }

  void onItemTapped(int index) {
    _pageController.jumpToPage(index);
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void onImpressionSuccess(IronSourceImpressionData? impressionData) {
    debugPrint('Impression Data: $impressionData');
  }

  @override
  void onInitializationComplete() {
    debugPrint('onInitializationComplete');
  }
}
