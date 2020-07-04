import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'DAC88CDF4C246CFD4CF2E332F51AB100';


class Ads {
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId:'ca-app-pub-8405717001980597~1330534671');
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    childDirected: true,
  );

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId:'ca-app-pub-8405717001980597/6398743118',
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 63.0, anchorType: AnchorType.bottom,);
  }

  static void hideBannerAd() async {
    await _bannerAd.dispose();
    _bannerAd = null;
  }
}