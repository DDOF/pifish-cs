import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var socket = IO.io('http://192.168.1.40:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true
    });
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.dashboard),
                  text: 'Dashboard',
                ),
                Tab(
                  icon: Icon(Icons.timeline),
                  text: 'Reports',
                ),
                Tab(
                  icon: Icon(Icons.settings_applications),
                  text: 'Settings',
                )
              ],
            ),
            title: Text('Blowfish'),
          ),
          body: TabBarView(
            children: [
              DashboardPage(channel: socket),
              Text("to be continued"),
              Text("settings")
            ],
          ),
        ),
      ),
    );
  }
}
