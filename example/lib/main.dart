//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

import 'package:beacons/beacons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'tab_monitoring.dart';
import 'tab_ranging.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  MyApp() {
    WidgetsFlutterBinding.ensureInitialized();
    Beacons.loggingEnabled = true;

    int notifId = 0;

    Beacons.backgroundMonitoringEvents().listen((event) async {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              onDidReceiveLocalNotification: (a, b, c, d) {});
      final MacOSInitializationSettings initializationSettingsMacOS =
          MacOSInitializationSettings();
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS,
              macOS: initializationSettingsMacOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (s) {});
      const IOSNotificationDetails iOSPlatformChannelSpecifics =
          IOSNotificationDetails(threadIdentifier: 'thread_id');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(iOS: iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
        ++notifId,
        event.type.toString(),
        event.state.toString(),
        platformChannelSpecifics,
      );
    });

    Beacons.configure(BeaconsSettings(
      android: BeaconsSettingsAndroid(
        logs: BeaconsSettingsAndroidLogs.info,
      ),
    ));
  }

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new CupertinoTabScaffold(
        tabBar: new CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              label: 'Track',
              icon: new Icon(Icons.location_searching),
            ),
            new BottomNavigationBarItem(
              label: 'Monitoring',
              icon: new Icon(Icons.settings_remote),
            ),
            new BottomNavigationBarItem(
              label: 'Settings',
              icon: new Icon(Icons.settings_input_antenna),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return new CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return new RangingTab();
                case 1:
                  return new MonitoringTab();
                default:
                  return new Container(
                    child: new Center(
                      child: new Text('TBD'),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
