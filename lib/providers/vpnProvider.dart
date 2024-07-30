import 'dart:async';

// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// import 'package:ndialog/ndialog.dart';
// import 'package:nizvpn/https/ServerAPI.dart';
import 'package:provider/provider.dart';

// import '../../ui/screens/subscriptionDetailScreen.dart';
// import '../https/ServerAPI.dart';

import '../modals/vpnConfig.dart';
import '../utils/NizVPN.dart';
import '../utils/preferences.dart';

class VpnProvider extends ChangeNotifier {
  VpnConfig? _vpnConfig;

  set vpnConfig(VpnConfig? vpnConfig) {
    _vpnConfig = vpnConfig;
    print("get best");
    notifyListeners();
  }

  VpnConfig? get vpnConfig => _vpnConfig;

  static VpnProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);
}
