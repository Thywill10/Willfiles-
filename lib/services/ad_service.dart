import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  BannerAd? bannerAd;

  void loadBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,

      adUnitId: BannerAd.testAdUnitId,

      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print("Banner Ad Loaded");
        },

        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Banner Ad Failed: $error");
        },
      ),

      request: const AdRequest(),
    );

    bannerAd!.load();
  }

  void disposeBanner() {
    bannerAd?.dispose();
  }
}