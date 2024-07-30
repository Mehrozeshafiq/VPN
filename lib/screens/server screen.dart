import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/servers_provider.dart';
import '../component/servers_screen.dart';

class ServerTabs extends StatefulWidget {
  const ServerTabs({super.key});

  @override
  State<ServerTabs> createState() => _ServerTabsState();
}

class _ServerTabsState extends State<ServerTabs> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServersProvider>(
        builder: (context, value, child) => DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey.shade900,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  title: Text('Select Country',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  bottom: TabBar(
                    indicatorColor: Color.fromARGB(255, 13, 171, 24),
                    tabs: [
                      Tab(
                        text: 'ALL  LOACTIONS',
                      ),
                      Tab(
                        text: 'RECOMMENDED',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    // Content of Tab 1
                    ServersScreen(
                      servers: value.freeServers,
                      tab: "All Locations",
                    ),
                    // Content of Tab 2
                    ServersScreen(
                      servers: value.proServers,
                      tab: "Recommended",
                    ),
                  ],
                ),
              ),
            ));
  }
}









