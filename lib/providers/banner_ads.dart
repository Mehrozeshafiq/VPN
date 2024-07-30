// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BannerProvider with ChangeNotifier {
//   BannerAd? _bannerAd;

//   BannerAd? getBannerAd() => _bannerAd;

//   void initAds() {
//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-5697489208417002/6531455654', // Replace with your banner ad unit ID
//       size: AdSize.banner,
//       request: AdRequest(
//         keywords: <String>['flutter', 'mobile', 'ads'],
//         contentUrl: 'https://example.com',
//         nonPersonalizedAds: true,
//       ),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           print('Banner Ad Loaded: ${ad.responseInfo}');
//           notifyListeners();
//         },
//         onAdFailedToLoad: (ad, error) {
//           print('Banner Ad Failed to Load: $error');
//         },
//       ),
//     );
//     _bannerAd!.load();
//   }
// }
