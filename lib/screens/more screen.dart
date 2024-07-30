import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vpnprowithjava/api/purchase_api.dart';
import 'package:vpnprowithjava/api/subscription_api.dart';
import 'payment_configurations.dart' as payment_configurations;
import '../providers/ads_provider.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:share_plus/share_plus.dart';

class MoreScreen extends StatefulWidget {
  
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  var uuid;
  final _paymentItems = <PaymentItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googlePayConfigFuture = PaymentConfiguration.fromAsset('gpay.json');
    // SharedPreferences.getInstance().then((value) {
    //   setState(() {
    //     uuid = value.getString("uuid_key");
    //   });
    //
    // });
  }
void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }
void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.technosofts.vpnmax&pcampaignid=web_share');
    if (!await launchUrl(url)) {
  throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
 

  var statusHeight = MediaQuery.of(context).viewPadding.top;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenSize = MediaQuery.of(context).size.height * MediaQuery.of(context).size.width;
    Future<void> opendialogbox()async{
    return showDialog<void>(
    context: context,
    barrierDismissible: false, 
      builder: (BuildContext context){
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
                height: height * 0.61,
                width: width - 50,
                color: Colors.grey[900],
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: size * 0.00005, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.electric_bolt,
                            color: Colors.yellow,
                            size: size * 0.000070,
                          ),
                          Text(
                            'Get Access to Ultra Server',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: size >= 370000
                                    ? size * 0.000050
                                    : size * 0.000055,
                                fontWeight: FontWeight.w700),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: size * 0.000070,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: InkWell(
                    onTap: () async {
  try {
    fetchOffers(context);
  } catch (e) {
    print('Error initializing PurchaseApi: $e');
  }
},

                        child: Container(
                          height: height * 0.07,
                          width: width * 0.81,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child:
                                   Text(
                                    'Monthly',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: size >= 370000
                                            ? size * 0.000052
                                            : size * 0.000057,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text(
                                    'Rs 315.00',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: size >= 370000
                                            ? size * 0.000052
                                            : size * 0.000057,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 14, 29, 163),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                       child: InkWell(
                      onTap: () async{
                       await PurchaseApi.init();
                      },
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.81,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  'Yearly',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: size >= 370000
                                          ? size * 0.000052
                                          : size * 0.000057,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  'Rs 3,240.00',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: size >= 370000
                                          ? size * 0.000052
                                          : size * 0.000057,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 14, 29, 163),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.81,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'One-Time Purchase',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size >= 370000
                                        ? size * 0.00005
                                        : size * 0.000055,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Rs 18,000',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size >= 370000
                                        ? size * 0.00005
                                        : size * 0.000055,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 13, 171, 24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // FutureBuilder<PaymentConfiguration>(
                    //     future: _googlePayConfigFuture,
                    //     builder: (context, snapshot) {
                    //       print(
                    //           "GPAY FILE CONFIG ${snapshot.data.toString()} ");
                    //       return GooglePayButton(
                    //         width: width * 0.8,
                    //         paymentConfiguration:
                    //             PaymentConfiguration.fromJsonString(
                    //                 payment_configurations.defaultGooglePay),
                    //         paymentItems: _paymentItems,
                    //         type: GooglePayButtonType.buy,
                    //         margin: const EdgeInsets.only(top: 15.0),
                    //         onPaymentResult: onGooglePayResult,
                    //         loadingIndicator: const Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       );
                    //     }),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                      child: Center(
                          child: Text(
                        'YOU CAN CANCEL YOUR SUBSCRIPTION OR FREE TRIAL AT ANY TIME BY CANCELING IT THROUGH YOUR GOOGLE ACCOUNT SETTING. OTHERWISE, IT WILL AUTOMATICALLY RENEW. CANCELLATION MUST BE DONE 24 HOURS BEFORE THE END OF THE CURRENT PERIOD. ',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: size * 0.000035,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    )
                  ],
                ),
              );
            }),
          );
        },
      );
    } // OpenDialog

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFoucs = FocusScope.of(context);
        if (!currentFoucs.hasPrimaryFocus) {
          currentFoucs.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: statusHeight + 10, left: screenSize * 0.00005),
              child: Container(
                height: screenHeight * 0.085,
                width: screenWidth * 0.91,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.electric_bolt,
                      color: Colors.amber,
                      size: screenSize * 0.00008,
                    ),
                    title: Text(
                      'Get Access to Ultra Server',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenSize >= 370000
                              ? screenSize * 0.000056
                              : screenSize * 0.000060,
                          fontWeight: FontWeight.w700),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        opendialogbox();
                      },
                      child: Container(
                        height: screenSize >= 370000
                            ? screenHeight * 0.037
                            : screenHeight * 0.04,
                        width: screenSize >= 370000
                            ? screenWidth * 0.19
                            : screenWidth * 0.20,
                        child: Center(
                            child: Text(
                          'UNLOCK',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: screenSize >= 370000
                                  ? screenSize * 0.000034
                                  : screenSize * 0.000038,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600),
                        )),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 13, 171, 24),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize * 0.00003, left: screenSize * 0.00005),
              child: InkWell(
                onTap: () {
                  Share.share('com.technosofts.vpnmax');
                 // StoreRedirect.redirect(androidAppId: 'com.technosofts.vpnmax');
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.91,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: screenSize * 0.00009,
                      ),
                      title: Text(
                        'Share',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenSize >= 370000
                                ? screenSize * 0.000056
                                : screenSize * 0.000060,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize * 0.00003, left: screenSize * 0.00005),
              child: InkWell(
                onTap: () {
                  StoreRedirect.redirect(
                      androidAppId: 'com.technosofts.vpnmax');
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.91,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.star_border,
                        color: Colors.white,
                        size: screenSize * 0.00009,
                      ),
                      title: Text(
                        'Rate this app',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenSize >= 370000
                                ? screenSize * 0.000056
                                : screenSize * 0.000060,
                            fontWeight: FontWeight.w800),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize * 0.00003, left: screenSize * 0.00005),
              child: InkWell(
                onTap: () {
                  StoreRedirect.redirect(
                      androidAppId: 'com.technosofts.vpnmax');
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.91,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.feedback,
                        color: Colors.white,
                        size: screenSize * 0.00009,
                      ),
                      title: Text(
                        'Feedback',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenSize >= 370000
                                ? screenSize * 0.000056
                                : screenSize * 0.000060,
                            fontWeight: FontWeight.w800),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize * 0.00003, left: screenSize * 0.00005),
              child: Container(
                height: screenHeight * 0.07,
                width: screenWidth * 0.91,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: ListTile(
                    title: Text(
                      'UUID',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenSize >= 370000
                              ? screenSize * 0.000056
                              : screenSize * 0.000060,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Text(
                        "09a91894-e93f-82eb32f2a3ef",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: screenSize * 0.00003),
                      ),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        height: screenSize >= 370000
                            ? screenHeight * 0.038
                            : screenHeight * 0.04,
                        width: screenSize >= 370000
                            ? screenWidth * 0.15
                            : screenWidth * 0.16,
                        child: Center(
                            child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: "09a91894-e93f-82eb32f2a3ef"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Copied to clipboard'),
                            ));
                          },
                          child: Text(
                            'COPY',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: screenSize >= 370000
                                    ? screenSize * 0.000034
                                    : screenSize * 0.000038,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 13, 171, 24),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    
  }
}
