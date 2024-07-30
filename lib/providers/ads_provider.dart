import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../resources/environment.dart';

class AdsProvider with ChangeNotifier {
  BannerAd? _bannerAd;
  InterstitialAd? intersAd1;
   bool _isAdLoaded = false;

  @override
  void initState() {
loadAds();
loadInterstitialAd();
  }

  BannerAd? getBannerAd() => _bannerAd;
void loadAds() {
    // TODO: Create a BannerAd instance
  _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5697489208417002/6531455654',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
            _isAdLoaded = true;
    
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
  _bannerAd?.load();
  }


Future<void> loadInterstitialAd() async {
final adUnitId ='ca-app-pub-5697489208417002/3905292318';
   final adRequest = AdRequest();
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          intersAd1 = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
        print('InterstitialAd failed to load: $error');

          },
      ),
    );
  }

void showInterstitialAd() {
    if (intersAd1 != null) {
      intersAd1!.show();
    }
  }
}
