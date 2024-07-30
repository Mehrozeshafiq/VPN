import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modals/vpnConfig.dart';
import '../modals/vpnServer.dart';
import '../providers/servers_provider.dart';
import '../providers/vpnProvider.dart';

// ignore: must_be_immutable
class ServersScreen extends StatefulWidget {
  String tab;
  List<VpnServer> servers;

  ServersScreen({
    super.key,
    required this.servers,
    required this.tab,
  });

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ServersProvider>(context);
    final controllerVPN = Provider.of<VpnProvider>(context);
    if (widget.servers.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No Servers Found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              // child: Divider(
              //   color: Colors.grey,
              //   height: 3,
              // ),
            );
          },
          itemCount: widget.servers.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.setSelectedIndex(index);
                controller.setSelectedTab(widget.tab);
                controllerVPN.vpnConfig =
                    VpnConfig.fromJson(widget.servers[index].toJson());
                // print(controllerVPN.vpnConfig.toString());
                Navigator.pop(context);
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                tileColor: Colors.grey.shade900,
                leading: Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'icons/flags/png/${widget.servers[index].countryCode.toLowerCase()}.png',
                              package: 'country_icons')),
                    )),
                title: Text(
                  widget.servers[index].country,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.check_circle,
                  size: 30,
                  color: index == controller.getSelectedIndex() &&
                          widget.tab == controller.getSelectedTab()
                      ? Colors.amber
                      : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
