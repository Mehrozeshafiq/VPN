import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpnprowithjava/api/purchase_api.dart';
import 'package:vpnprowithjava/providers/ads_provider.dart';
import 'package:vpnprowithjava/providers/animation_provider.dart';
import 'package:vpnprowithjava/providers/appsProvider.dart';
import 'package:vpnprowithjava/providers/deviceDetailProvider.dart';
import 'package:vpnprowithjava/providers/servers_provider.dart';
import 'package:vpnprowithjava/providers/vpnProvider.dart';
import 'package:vpnprowithjava/providers/vpn_connection_provider.dart';
import 'package:vpnprowithjava/screens/splashScreen.dart';
import 'classes/navbar.dart';
void main() async {
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.grey[900],
  ));
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await PurchaseApi.init();

  await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_)
  {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ServersProvider()),
      ChangeNotifierProvider(create: (_) => DeviceDetailProvider()),
      ChangeNotifierProvider(create: (_) => AppsProvider()),
      ChangeNotifierProvider(create: (_) => VpnProvider()),
      ChangeNotifierProvider(create: (_) => VpnConnectionProvider()),
      ChangeNotifierProvider(create: (_) => CountProvider()),
      ChangeNotifierProvider(create: (_) => AdsProvider()),
    ], child: const MyApp()));
  });
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    MobileAds.instance.initialize();
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}