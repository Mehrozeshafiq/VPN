import 'dart:convert';
import 'package:flutter/material.dart';
import '../modals/vpnConfig.dart';
import '../modals/vpnServer.dart';
import '../providers/vpnProvider.dart';
import '../resources/environment.dart';
import 'httpConnection.dart';
import 'package:http/http.dart' as http;

class VpnServerHttp extends HttpConnection {
  VpnServerHttp(BuildContext context) : super(context);

  Future<List<VpnServer>> getServers(String type) async {
    List<VpnServer> servers = [];
    // Map<String, String> header = {'auth_token': 'VBrcKTECHNO5566'}; origion
    Map<String, String> header = {'auth_token': 'VBrcKTECHNO5566'};
    final res =
        await http.get(Uri.parse("${api}servers/$type"), headers: header);
    // print("${res.statusCode}:${res.body}");
    try {
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body.toString());
        json = json['data'];
        // print(json['data'] as List<Map<String,dynamic>>);
        for (final js in json) {
          final server = VpnServer.fromJson(js);
          servers.add(server);
        }
      } else {
        servers = [];
      }
      print("_____________________________DATA_____________________________");
      print(type);
    } catch (e) {
      servers = [];
      print(e.toString());
    }
    return servers;
  }

  Future<VpnConfig?> getBestServer(BuildContext context) async {
    Map<String, String> header = {'auth_token': 'VBrcKTECHNO5566'};
    final res =
        await http.get(Uri.parse("${api}servers/best"), headers: header);
    final vpn = VpnProvider.instance(context);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body.toString());
      // print("____________data_______________");
      // print(json);

      VpnConfig server = VpnConfig.fromJson(json["data"]);
      vpn.vpnConfig = server;
    }
    print("__________________________________________");
    print("Status for best api  : ${res.body.toString()}");
    return vpn.vpnConfig;
  }
}
