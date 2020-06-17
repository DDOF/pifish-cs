import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DashboardPage extends StatefulWidget {
  final IO.Socket channel;

  const DashboardPage({Key key, this.channel}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  StreamController<int> tempController = StreamController();

  @override
  Widget build(BuildContext context) {
    widget.channel.on("temp", (data) => tempController.add(data));
    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(null, color, Icons.thumb_down, 'In temp'),
          _buildButtonColumn(tempController.stream, color, null, 'Ext temp'),
          _buildButtonColumn(null, Colors.red, Icons.warning, 'PH'),
        ],
      ),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buttonSection,
            Center(
              child: Card(
                  child: Row(
                children: [
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Column(
                          children: [
                            Icon(Icons.power_settings_new),
                            Text("Light")
                          ],
                        ),
                        onPressed: () {
                          widget.channel.emit('light', 'onoff');
                        },
                      ),
                    ],
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //widget.channel.disconnect();
    super.dispose();
  }

  Column _buildButtonColumn(
      Stream data, Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: data,
          builder: (context, snapshot) {
            return Row(
              children: [
                Text(snapshot.hasData ? '${snapshot.data.toString()}°C' : '',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                Icon(icon, color: color)
              ],
            );
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
