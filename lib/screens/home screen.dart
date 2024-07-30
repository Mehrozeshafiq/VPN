import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpnprowithjava/screens/allowed_app_screen.dart';
import 'package:vpnprowithjava/screens/server%20screen.dart';
import '../https/vpnServerHttp.dart';
import '../modals/ApplicationModel.dart';
import '../providers/ads_provider.dart';
import '../providers/animation_provider.dart';
import '../providers/appsProvider.dart';
import '../providers/deviceDetailProvider.dart';
import '../providers/servers_provider.dart';
import '../providers/vpnProvider.dart';
import '../providers/vpn_connection_provider.dart';
import '../utils/GetApps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  var v5;
  var data;
  

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _getServers();
    _getAllApps();
    // Start listening for network status changes
  }

  bool _isLoading = false;
  bool _isConnected = false;
  int _progressPercentage = 0;

  void _startLoading() {
    setState(() {
      _isLoading = true;
      _updateProgress();
    });
  }

  void _updateProgress() {
    Future.delayed(Duration(milliseconds: 50), () {
      if (_progressPercentage < 100) {
        setState(() {
          final provider =
              Provider.of<VpnConnectionProvider>(context, listen: false);
          if (provider.stage?.toString() == "VPNStage.connected") {
            _progressPercentage = 100;
          //  Provider.of<AdsProvider>(context, listen: false)
             //   .showInterstitialAd();
          } else {
            _progressPercentage++;
          }
          _updateProgress();
        });
      } else {
        setState(() {
          _isLoading = false;
          _isConnected = true;
        });
      }
    });
  }

  void _disconnect() {
    setState(() {
      _isConnected = false;
      _progressPercentage = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Provider.of<AdsProvider>(context, listen: false).dispose();// Cancel the subscription when the widget is disposed
    _connectivitySubscription?.cancel();
  }

  _getAllApps() async {
    await Provider.of<AppsProvider>(context, listen: false).setDisallowList();
    List<ApplicationModel> appsList = [];
    Provider.of<AppsProvider>(context, listen: false).updateLoader(true);
    final apps = await GetApps.GetAllAppInfo();
    for (final app in apps) {
      appsList.add(
        ApplicationModel(isSelected: true, app: app),
      );
    }
    Provider.of<AppsProvider>(context, listen: false).setAllApps(appsList);
    Provider.of<AppsProvider>(context, listen: false).updateLoader(false);
  //  Provider.of<AdsProvider>(context, listen: false).loadAds();
 //   Provider.of<AdsProvider>(context, listen: false).loadInterstitialAd();

    Provider.of<DeviceDetailProvider>(context, listen: false).getDeviceInfo(v5);
    // Provider.of<VpnConnectionProvider>(context, listen: false).initialize();
  }

  _getServers() async {
    await VpnServerHttp(context).getBestServer(context);
    final myProvider = Provider.of<ServersProvider>(context, listen: false);
    if (myProvider.freeServers.isEmpty || myProvider.proServers.isEmpty) {
      final free = await VpnServerHttp(context).getServers("free");
      myProvider.setFreeServers(free);
      final pro = await VpnServerHttp(context).getServers("premium");
      myProvider.setProServers(pro);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      // No internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              var size = MediaQuery.of(context).size.height *
                  MediaQuery.of(context).size.width;
              return Container(
                height: size >= 370000 ? 450 : 400,
                width: width - 50,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Something went wrong.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 14, 29, 163),
                            fontSize: size >= 370000
                                ? size * 0.000073
                                : size * 0.000082,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Container(
                        height: height * 0.09,
                        width: width * 0.81,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'Please check your internet',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: size >= 370000
                                        ? size * 0.00005
                                        : size * 0.00007,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' connection',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: size >= 370000
                                        ? size * 0.00005
                                        : size * 0.00007,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        height: size >= 370000 ? height * 0.15 : height * 0.16,
                        width: size >= 370000 ? width * 0.35 : width * 0.4,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage(
                                "assets/images/nointernetimage.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size >= 370000 ? height * 0.068 : height * 0.08),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: height * 0.065,
                          width: width * 0.84,
                          child: Center(
                            child: Text(
                              'Refresh',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: size * 0.00006,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 14, 29, 163),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      );
    }
  }

double bytesPerSecondToMbps(double bytesPerSecond) {
    const bitsInByte = 8;
    const bitsInMegabit = 1000000;
    return (bytesPerSecond * bitsInByte) / bitsInMegabit;
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).viewInsets.bottom;
    double safeAreaHeightTop = MediaQuery.of(context).viewInsets.top;
    EdgeInsets safeArea = MediaQuery.of(context).padding;
    double topPadding = safeArea.top;
    double screenHeight1 = MediaQuery.of(context).size.height;
    double safeAreaHeightBottom = MediaQuery.of(context).viewInsets.bottom;
    double appBarHeight = AppBar().preferredSize.height;
    double screenHeightMinusSafeAreaAndAppBar =
        screenHeight1 - safeAreaHeight - appBarHeight;
    //double usableScreenHeight = screenHeight - safeAreaHeight - appBarHeight - topPadding;
    double usableScreenHeight = screenHeight1 -
        safeAreaHeightTop -
        safeAreaHeightBottom -
        appBarHeight -
        topPadding;

    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var screenHeight = usableScreenHeight;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenSize =
        MediaQuery.of(context).size.height * MediaQuery.of(context).size.width;
    print('height: $screenHeight ');
    print('width : $screenWidth');
    print('total size $screenSize');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: statusHeight, left: screenWidth * 0.025),
                  child: Container(
                    color: Colors.black,
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.57,
                    child: Row(
                      children: [
                        Text(' VPN',
                            style: GoogleFonts.poppins(
                                fontSize: screenSize >= 370000
                                    ? screenSize * 0.00011
                                    : screenSize * 0.00013,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0)),
                        Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            'Max',
                            style: GoogleFonts.poppins(
                                fontSize: screenSize >= 370000
                                    ? screenSize * 0.00011
                                    : screenSize * 0.00013,
                                color: Color.fromARGB(255, 13, 171, 24),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: statusHeight, right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllowedAppsScreen()));
                    }, // onTap
                    child: Container(
                      height: screenHeight * 0.055,
                      width: screenWidth * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        'APP FILTER',
                        style: GoogleFonts.poppins(
                            fontSize: screenSize >= 370000
                                ? screenSize * 0.000039
                                : screenSize * 0.000045,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Container(
                    height: screenHeight * 0.125,
                    width: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Consumer<VpnConnectionProvider>(
                            builder: (context, value, child) => Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text(
                                            'UPLOAD',
                                            style: GoogleFonts.poppins(
                                                fontSize: screenSize >= 370000
                                                    ? screenSize * 0.00004
                                                    : screenSize * 0.000045,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 2.0),
                                          ),
                                        ),
                                        Text(
                                          value.stage?.toString() ==
                                                  "VPNStage.connected"
                                              ? bytesPerSecondToMbps(
                                                      double.parse(value.status!
                                                              .byteOut ??
                                                          "0000"))
                                                  .toStringAsFixed(2)
                                              : "00:00",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 2.0),
                                        ),
                                        Text(
                                          'mbps',
                                          style: GoogleFonts.poppins(
                                              fontSize: screenSize >= 370000
                                                  ? screenSize * 0.000044
                                                  : screenSize * 0.000047,
                                              color: Color.fromARGB(
                                                  255, 13, 171, 24),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Container(
                    height: screenHeight * 0.125,
                    width: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Consumer<VpnConnectionProvider>(
                            builder: (context, value, child) => Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text(
                                            'DOWNLOAD',
                                            style: GoogleFonts.poppins(
                                                fontSize: screenSize >= 370000
                                                    ? screenSize * 0.00004
                                                    : screenSize * 0.000045,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 2.0),
                                          ),
                                        ),
                                        Text(
                                          value.stage?.toString() ==
                                                  "VPNStage.connected"
                                              ? bytesPerSecondToMbps(
                                                      double.parse(value
                                                              .status!.byteIn ??
                                                          "0000"))
                                                  .toStringAsFixed(2)
                                              : "00:00",
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 2.0),
                                        ),
                                        Text(
                                          'mbps',
                                          style: GoogleFonts.poppins(
                                              fontSize: screenSize >= 370000
                                                  ? screenSize * 0.000044
                                                  : screenSize * 0.000047,
                                              color: Color.fromARGB(
                                                  255, 13, 171, 24),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2.0),
                          
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),
                  ),
                ),
              ],
            ),
//            Consumer<AdsProvider>(
//   builder: (context, value, child) {
//     final bannerAd = value.getBannerAd();
//     if (bannerAd != null) {
//       // Now, you can display the ad
//       return Container(
//         alignment: Alignment.center,
//         width: bannerAd.size.width.toDouble(),
//         height: screenHeight * 0.1,
//         child: AdWidget(ad: bannerAd),
//       );
//     } else {
//       // Display a placeholder or alternative content
//       return Padding(
//         padding: EdgeInsets.only(top: 7),
//         child: Container(
//           height: screenHeight * 0.092,
//           width: screenWidth * 0.93,
//           color: Colors.transparent,
//           //child: Center(child: Text('This is Google Ad Container......!', style: GoogleFonts.poppins(fontSize: 15, wordSpacing: 2, fontWeight: FontWeight.w500)),
//         ),
//       );
//     }
//   },
// )
// ,
            Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.07),
                child: Consumer<VpnConnectionProvider>(
                  builder: (context, value, child) => Container(
                    height: screenHeight * 0.43,
                    width: screenWidth * 0.85,
                    child: value.stage?.toString() == "VPNStage.connected"
                        ? Image.asset(
                            "assets/images/connectedgiffy.gif",
                          )
                        : Image.asset(
                            "assets/images/firstimagegiffy.gif",
                          ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.02, left: 10, right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const ServerTabs();
                  }));
                },
                child: Container(
                  height: screenHeight * 0.075,
                  width: screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    //border: Border.all(color: Colors.white)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<VpnProvider>(
                        builder: (context, value, child) => value.vpnConfig ==
                                null
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                child: Icon(
                                  Icons.flag,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Container(
                                    height: 38,
                                    width: 40,
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'icons/flags/png/${value.vpnConfig!.countryCode.toLowerCase()}.png',
                                              package: 'country_icons')),
                                    )),
                              ),
                      ),
                      Expanded(
                        child: Consumer<VpnProvider>(
                            builder: (context, value, child) => Text(
                                  value.vpnConfig == null
                                      ? "Select your country"
                                      : value.vpnConfig!.country,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: screenSize * 0.00006,
                                      fontWeight: FontWeight.bold),
                                )),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.011, left: 10, right: 10),
              child: InkWell(
                  onTap: () {},
                  child: Consumer<CountProvider>(
                      builder: (context, value1, child) {
                    return Container(
                      height: screenHeight * 0.075,
                      width: screenWidth * 0.95,
                      child: _isLoading
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Color.fromARGB(255, 13, 171, 24),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 14, 29, 163),
                                    width: (_progressPercentage / 100) *
                                        screenWidth *
                                        0.95,
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: (_progressPercentage / 100) *
                                            screenWidth *
                                            0.95,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 40.0, top: screenHeight * 0.01),
                                      child: Center(
                                        child: Text(
                                          'CONNECTING...($_progressPercentage%) ',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 2.0),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : !_isConnected
                              ? Consumer<VpnConnectionProvider>(
                                  builder: (context, value, child) =>
                                      ElevatedButton(
                                        onPressed: () async {
                                          // print();
                                          String comp =
                                              value.stage?.toString() == null
                                                  ? "Disconnect"
                                                  : value.stage
                                                      .toString()
                                                      .split('.')
                                                      .last;
                                          if (comp == "connected") {
                                            value.engine.disconnect();
                                            value.resetRadius();
                                          } else {
                                            value.setRadius();
                                            // final adsProvider =
                                            //     Provider.of<AdsProvider>(
                                            //         context,
                                            //         listen: false);
                                            // adsProvider
                                            //     .loadInterstitialAd()
                                            //     .then((_) {
                                            //   adsProvider.showInterstitialAd();
                                            // });
                                            final vpnProvider =
                                                Provider.of<VpnProvider>(
                                                    context,
                                                    listen: false);
                                            final apps =
                                                Provider.of<AppsProvider>(
                                                    context,
                                                    listen: false);
                                            if (value.getInitCheck()) {
                                              value.initialize();
                                            }
                                            // vpnProvider.vpnConfig!.country
                                            if (vpnProvider.vpnConfig != null) {
                                              _startLoading();
                                              await value.initPlatformState(
                                                  vpnProvider.vpnConfig!.ovpn,
                                                  vpnProvider
                                                      .vpnConfig!.country,
                                                  apps.getDisallowedList,
                                                  vpnProvider.vpnConfig!
                                                          .username ??
                                                      "",
                                                  vpnProvider.vpnConfig!
                                                          .password ??
                                                      "");
                                              await Future.delayed(
                                                  const Duration(seconds: 3));
                                            } else {
                                              _updateConnectionStatus(
                                                  ConnectivityResult.none);
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return const ServerTabs();
                                              }));
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          )),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color.fromARGB(
                                                      255, 13, 171, 24)),
                                        ),
                                        child: Text(
                                          'CONNECT',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: screenSize * 0.000048,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 2.0),
                                        ),
                                      ))
                              : Consumer<VpnConnectionProvider>(

                                  builder: (context, value, child) =>
                                      ElevatedButton(
                                    onPressed: () async {
                                      _disconnect();
                                      value.engine.disconnect();
                                      value.resetRadius();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('VPN DISCONNECT'),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                      backgroundColor: MaterialStatePropertyAll(
                                          value.stage?.toString() ==
                                                  "VPNStage.connected"
                                              ? Color.fromARGB(255, 14, 29, 163)
                                              : Color.fromARGB(
                                                  255, 96, 124, 191)),
                                    ), //

                                    child: Text(
                                      value.stage?.toString() ==
                                              "VPNStage.connected"
                                          ? 'DISCONNECT'
                                          : 'PLEASE WAIT...',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: screenSize * 0.000048,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.0),
                                    ),
                                  ),
                                ),
                      /*  Center(
                    child: value1 .isconnect? Text (
                      'DISCONNECT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0),
                    ):Text (
                      'CONNECT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0),
                    ),
                  ),*/
                      decoration: BoxDecoration(
                          color: value1.isconnect
                              ? Color.fromARGB(255, 14, 29, 163)
                              : Color.fromARGB(255, 13, 171, 24),
                          borderRadius: BorderRadius.circular(15)),
                      //Provider.of<AdsProvider>(
                      //                 context,
                      //                 listen: false)
                      //                 .showInterstitialAd();
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
