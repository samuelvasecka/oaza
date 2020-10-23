import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:oaza/screens/day.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/objects/step.dart';
import 'package:intl/intl.dart';

class NotificationHandler {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Save _save = Save();
  AllSteps _allSteps = AllSteps.getInstance();
  BuildContext context;

  void initState() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  List<String> names = [
    "Ježiš Kristus",
    "Nepoškvrnená",
    "Duch Svätý",
    "Cirkev",
    "Slovo Božie",
    "Modlitba",
    "Liturgia",
    "Svedectvo",
    "Nová kultúra",
    "Agape",
  ];

  Future onSelectNotification(String payload) async {
    /*await _save.loadSteps();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DayPage(
        actualDay: 1,
        actualStep: _allSteps.getActualDay().step,
        name: names[_allSteps.getActualDay().step == -1
            ? 0
            : _allSteps.getActualDay().step - 1],
        day: _allSteps.getActualDay(),
      );
    }));*/
  }

  Future onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    /*return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return DayPage(
                actualDay: 1,
                actualStep: _allSteps.getActualDay().step,
                name: names[_allSteps.getActualDay().step == -1
                    ? 0
                    : _allSteps.getActualDay().step - 1],
                day: _allSteps.getActualDay(),
              );
            }));
          },
          child: Text("Show me"),
        )
      ],
    );*/
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> findEvent(Map events, Map event) async {
    int index = 0;
    for (int i = 0; i < events["events"].length; i++) {
      if (event["name"] == events["events"][i]["name"] &&
          event["date"] == events["events"][i]["date"]) {
        index = i;
      }
    }

    events["events"][index] = event;
    await _save.saveEvents(events);
    return events;
  }

  Future<Map> scheduleNotification(String title, String body, Map event,
      Map events, DateTime scheduledNotificationDateTime) async {
    int id = await _save.loadId();

    event["alarm"] = true;
    event["alarm_time"] =
        DateFormat("HH:mm").format(scheduledNotificationDateTime);
    print(event["alarm_time"]);
    event["alarm_code"] = id;
    await findEvent(events, event);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "schedule channel id",
      'schedule channel name',
      'schedule channel description',
      icon: 'app_icon',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(id, title, body,
        scheduledNotificationDateTime, platformChannelSpecifics);
    id++;
    await _save.saveId(id);
    return event;
  }

  Future<void> scheduleNotificationPeriodically(
      int id, String title, String body, Time time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "periodically channel id",
      'periodically channel name',
      'periodically channel description',
      icon: 'app_icon',
    );
    RepeatInterval repeatInterval = RepeatInterval.Daily;
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, platformChannelSpecifics);
  }

  Future<void> turnOffNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> turnOffNotificationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<Map> turnOffNotificationByIdEvents(
    Map events,
    Map event,
  ) async {
    await flutterLocalNotificationsPlugin.cancel(event["alarm_code"]);
    event["alarm"] = false;
    event["alarm_time"] = null;
    event["alarm_code"] = null;
    await findEvent(events, event);
    return event;
  }
}
