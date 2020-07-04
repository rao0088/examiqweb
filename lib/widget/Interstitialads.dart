import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'DAC88CDF4C246CFD4CF2E332F51AB100';


class Adis {
  static InterstitialAd myInterstitial;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId:'ca-app-pub-8405717001980597~1330534671');
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    childDirected: true,
  );

  static InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-8405717001980597/6199717971',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void showInterstitialAd() {
    if (myInterstitial == null) myInterstitial = _createInterstitialAd();
    myInterstitial
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom,);
  }

  static void hideBannerAd() async {
    await myInterstitial.dispose();
    myInterstitial = null;
  }
}