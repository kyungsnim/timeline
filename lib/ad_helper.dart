import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1738707641643524/7436336659';
      // return 'ca-app-pub-3940256099942544/6300978111'; // test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1738707641643524/8351669369';
      // return 'ca-app-pub-3940256099942544/2934735716'; // test
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1738707641643524/5541673191";
      // return "ca-app-pub-3940256099942544/1033173712"; // test
    } else if (Platform.isIOS) {
      return "ca-app-pub-1738707641643524/4750216143";
      // return "ca-app-pub-3940256099942544/4411468910"; // test
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/5224354917";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/1712485313";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }
}