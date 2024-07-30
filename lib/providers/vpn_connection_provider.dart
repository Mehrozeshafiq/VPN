import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnConnectionProvider with ChangeNotifier {
  double radius = 0;

  void setRadius() {
    radius = 0.25;
    notifyListeners();
  }

  void resetRadius() {
    radius = 0;
    notifyListeners();
  }

  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool _init = true;

  bool getInitCheck() => _init;

  // String defaultVpnUsername = "vpnbook";
  // String defaultVpnPassword = "c9c4b4a";

  String defaultVpnUsername = "freeopenvpn";

  // String defaultVpnPassword = "565027632";
  String defaultVpnPassword = "605196725";
  String config = "YOUR OPENVPN CONFIG HERE";

  void initialize() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        status = data;
        notifyListeners();
      },
      onVpnStageChanged: (data, raw) {
        stage = data;
        notifyListeners();
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        this.stage = stage;
        notifyListeners();
      },
      lastStatus: (status) {
        this.status = status;
        notifyListeners();
      },
    );
    _init = true;
    notifyListeners();
  }

  Future<void> initPlatformState(String ovpn, String country,
      List<String> _disallowList, String username, String pass) async {
    print("username $username");
    print("username $pass");

    config = ovpn;
    engine.connect(config, country,
        username: username,
        password: pass,
        bypassPackages: _disallowList,
        certIsRequired: true);
    // engine.connect(config, country);
  }
}
