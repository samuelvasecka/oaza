import 'package:flutter/material.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/screens/login.dart';
import 'package:oaza/main.dart';
import 'package:oaza/functions/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  NavigationBloc navigationBloc;
  SettingsPage(this.navigationBloc);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Profile _profile = Profile.getInstance();
  Save _save = Save();
  NotificationHandler notificationHandler = NotificationHandler();

  Widget getPart({List<Widget> body, String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: Color(0xAA707070),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: body,
          ),
        )
      ],
    );
  }

  Map notification = {
    "morning": false,
    "morning_time": "00:00",
    "lunch": false,
    "lunch_time": "00:00",
    "evening": false,
    "evening_time": "00:00",
    "notifications": false,
  };

  Future<void> loadNotifications() async {
    notification = await _save.loadNotification();
    setState(() {});
  }

  @override
  void initState() {
    loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Nastavenia"),
        actions: [
          FlatButton(
            child: Text(
              "Odhlásiť sa",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              _profile.setName("");
              _profile.setGroupId("");
              _profile.setStepsStart({});
              _profile.setRoles([]);
              _profile.setEmail("");
              _profile.setLoggedIn(false);
              _profile.setPassword("");
              _profile.setActualStepDay({
                "step": 1,
                "day": 1,
                "started": false,
                "start_date": null,
              });
              notificationHandler.turnOffNotification();
              await _save.saveEvents({"events": [], "error": 0});
              await _save.saveNotification({
                "morning": false,
                "morning_time": "00:00",
                "lunch": false,
                "lunch_time": "00:00",
                "evening": false,
                "evening_time": "00:00",
                "notifications": false,
              });
              await _save.saveProfile(_profile.toJson());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage(widget.navigationBloc)),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(
              height: 37,
            ),
            getPart(
              title: "Osobný profil",
              body: [
                Text(
                  _profile.fullName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _profile.email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _profile.groupId,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            getPart(
              title: "Všeobecné nastavenia",
              body: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upozornenia",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: notification["notifications"],
                      onChanged: (bool value) async {
                        if (value == false) {
                          for (int i = 0; i < 3; i++) {
                            notificationHandler.turnOffNotificationById(i);
                          }
                        } else {
                          if (Platform.isIOS) {
                            notificationHandler.requestIOSPermissions();
                          }
                          for (int i = 0; i < 3; i++) {
                            List names = ["morning", "lunch", "evening"];
                            List names2 = ["Ranná", "Obedná", "Večerná"];
                            if (notification["${names[i]}"]) {
                              print(i);
                              var time = Time(
                                  int.parse(notification["${names[i]}_time"]
                                      .toString()
                                      .substring(0, 2)),
                                  int.parse(notification["${names[i]}_time"]
                                      .toString()
                                      .substring(3, 5)),
                                  0);
                              notificationHandler
                                  .scheduleNotificationPeriodically(
                                      i,
                                      "${names2[i]} pripomienka",
                                      "Nezabudni sa pomodliť.",
                                      time);
                            }
                          }
                        }
                        setState(() {
                          notification["notifications"] = value;
                        });
                        await _save.saveNotification(notification);
                      },
                      activeColor: Color(0xFFE4C103),
                      activeTrackColor: Color(0xFF5F5000),
                      inactiveTrackColor: Color(0x61FFFFFF),
                    ),
                  ],
                ),
                notification["notifications"]
                    ? Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(4),
                            elevation: 0,
                            color: Color(0x55000000),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ranná pripomienka",
                                          style: TextStyle(
                                            color: Color(0xFFFFD800),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Každý deň",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateTime = DateTime.now();
                                        TimeOfDay time = await showTimePicker(
                                          cancelText: "Zrušiť",
                                          helpText:
                                              "Vyber čas rannej pripomienky",
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: dateTime.hour,
                                              minute: dateTime.minute),
                                          builder: (BuildContext context,
                                              Widget child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                primaryColor:
                                                    const Color(0xFF212121),
                                                accentColor:
                                                    const Color(0xFF212121),
                                                colorScheme: ColorScheme.light(
                                                    primary: const Color(
                                                        0xFF212121)),
                                                buttonTheme: ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .primary),
                                              ),
                                              child: child,
                                            );
                                          },
                                        );
                                        if (time != null) {
                                          setState(() {
                                            notification["morning_time"] =
                                                "${time.hour.toString().length == 1 ? "0${time.hour}" : time.hour}:${time.minute.toString().length == 1 ? "0${time.minute}" : time.minute}";
                                          });
                                          await _save
                                              .saveNotification(notification);
                                          if (notification["morning"]) {
                                            notificationHandler
                                                .turnOffNotificationById(0);
                                            var time1 = Time(
                                                int.parse(
                                                    notification["morning_time"]
                                                        .toString()
                                                        .substring(0, 2)),
                                                int.parse(
                                                    notification["morning_time"]
                                                        .toString()
                                                        .substring(3, 5)),
                                                0);
                                            notificationHandler
                                                .scheduleNotificationPeriodically(
                                                    0,
                                                    "Ranná pripomienka",
                                                    "Nezabudni sa pomodliť.",
                                                    time1);
                                          }
                                        }
                                      },
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/time.png",
                                              width: 25,
                                              height: 25,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              notification["morning_time"],
                                              style: TextStyle(
                                                color: Color(0xFFBFBFBF),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: notification["morning"],
                                      onChanged: (value) async {
                                        if (value == false) {
                                          notificationHandler
                                              .turnOffNotificationById(0);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Ranná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja ranná pripomienka je vypnutá.",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        } else {
                                          var time = Time(
                                              int.parse(
                                                  notification["morning_time"]
                                                      .toString()
                                                      .substring(0, 2)),
                                              int.parse(
                                                  notification["morning_time"]
                                                      .toString()
                                                      .substring(3, 5)),
                                              0);
                                          notificationHandler
                                              .scheduleNotificationPeriodically(
                                                  0,
                                                  "Ranná pripomienka",
                                                  "Nezabudni sa pomodliť.",
                                                  time);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Ranná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja ranná pripomienka je nastavená na ${notification["morning_time"]}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        }
                                        setState(() {
                                          notification["morning"] = value;
                                        });

                                        await _save
                                            .saveNotification(notification);
                                      },
                                      activeColor: Color(0xFFE4C103),
                                      activeTrackColor: Color(0xFF5F5000),
                                      inactiveTrackColor: Color(0x61FFFFFF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(4),
                            elevation: 0,
                            color: Color(0x55000000),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Obedná pripomienka",
                                          style: TextStyle(
                                            color: Color(0xFFFFD800),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Každý deň",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateTime = DateTime.now();
                                        TimeOfDay time = await showTimePicker(
                                          cancelText: "Zrušiť",
                                          helpText:
                                              "Vyber čas obednej pripomienky",
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: dateTime.hour,
                                              minute: dateTime.minute),
                                          builder: (BuildContext context,
                                              Widget child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                primaryColor:
                                                    const Color(0xFF212121),
                                                accentColor:
                                                    const Color(0xFF212121),
                                                colorScheme: ColorScheme.light(
                                                    primary: const Color(
                                                        0xFF212121)),
                                                buttonTheme: ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .primary),
                                              ),
                                              child: child,
                                            );
                                          },
                                        );
                                        if (time != null) {
                                          setState(() {
                                            notification["lunch_time"] =
                                                "${time.hour.toString().length == 1 ? "0${time.hour}" : time.hour}:${time.minute.toString().length == 1 ? "0${time.minute}" : time.minute}";
                                          });
                                          await _save
                                              .saveNotification(notification);
                                          if (notification["lunch"]) {
                                            notificationHandler
                                                .turnOffNotificationById(0);
                                            var time1 = Time(
                                                int.parse(
                                                    notification["lunch_time"]
                                                        .toString()
                                                        .substring(0, 2)),
                                                int.parse(
                                                    notification["lunch_time"]
                                                        .toString()
                                                        .substring(3, 5)),
                                                0);
                                            notificationHandler
                                                .scheduleNotificationPeriodically(
                                                    1,
                                                    "Obedná pripomienka",
                                                    "Nezabudni sa pomodliť.",
                                                    time1);
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/time.png",
                                            width: 25,
                                            height: 25,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            notification["lunch_time"],
                                            style: TextStyle(
                                              color: Color(0xFFBFBFBF),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: notification["lunch"],
                                      onChanged: (value) async {
                                        if (value == false) {
                                          notificationHandler
                                              .turnOffNotificationById(1);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Obedná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja obedná pripomienka je vypnutá.",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        } else {
                                          var time = Time(
                                              int.parse(
                                                  notification["lunch_time"]
                                                      .toString()
                                                      .substring(0, 2)),
                                              int.parse(
                                                  notification["lunch_time"]
                                                      .toString()
                                                      .substring(3, 5)),
                                              0);
                                          notificationHandler
                                              .scheduleNotificationPeriodically(
                                                  1,
                                                  "Obedná pripomienka",
                                                  "Nezabudni sa pomodliť.",
                                                  time);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Obedná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja obedná pripomienka je nastavená na ${notification["lunch_time"]}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        }
                                        setState(() {
                                          notification["lunch"] = value;
                                        });

                                        await _save
                                            .saveNotification(notification);
                                      },
                                      activeColor: Color(0xFFE4C103),
                                      activeTrackColor: Color(0xFF5F5000),
                                      inactiveTrackColor: Color(0x61FFFFFF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(4),
                            elevation: 0,
                            color: Color(0x55000000),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Večerná pripomienka",
                                          style: TextStyle(
                                            color: Color(0xFFFFD800),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Každý deň",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateTime = DateTime.now();
                                        TimeOfDay time = await showTimePicker(
                                          cancelText: "Zrušiť",
                                          helpText:
                                              "Vyber čas večernej pripomienky",
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: dateTime.hour,
                                              minute: dateTime.minute),
                                          builder: (BuildContext context,
                                              Widget child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                primaryColor:
                                                    const Color(0xFF212121),
                                                accentColor:
                                                    const Color(0xFF212121),
                                                colorScheme: ColorScheme.light(
                                                    primary: const Color(
                                                        0xFF212121)),
                                                buttonTheme: ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .primary),
                                              ),
                                              child: child,
                                            );
                                          },
                                        );
                                        if (time != null) {
                                          setState(() {
                                            notification["evening_time"] =
                                                "${time.hour.toString().length == 1 ? "0${time.hour}" : time.hour}:${time.minute.toString().length == 1 ? "0${time.minute}" : time.minute}";
                                          });
                                          await _save
                                              .saveNotification(notification);
                                          if (notification["evening"]) {
                                            notificationHandler
                                                .turnOffNotificationById(0);
                                            var time1 = Time(
                                                int.parse(
                                                    notification["evening_time"]
                                                        .toString()
                                                        .substring(0, 2)),
                                                int.parse(
                                                    notification["evening_time"]
                                                        .toString()
                                                        .substring(3, 5)),
                                                0);
                                            notificationHandler
                                                .scheduleNotificationPeriodically(
                                                    2,
                                                    "Večerná pripomienka",
                                                    "Nezabudni sa pomodliť.",
                                                    time1);
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/time.png",
                                            width: 25,
                                            height: 25,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            notification["evening_time"],
                                            style: TextStyle(
                                              color: Color(0xFFBFBFBF),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: notification["evening"],
                                      onChanged: (value) async {
                                        if (value == false) {
                                          notificationHandler
                                              .turnOffNotificationById(2);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Večerná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja večerná pripomienka je vypnutá.",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        } else {
                                          var time = Time(
                                              int.parse(
                                                  notification["evening_time"]
                                                      .toString()
                                                      .substring(0, 2)),
                                              int.parse(
                                                  notification["evening_time"]
                                                      .toString()
                                                      .substring(3, 5)),
                                              0);
                                          notificationHandler
                                              .scheduleNotificationPeriodically(
                                                  2,
                                                  "Večerná pripomienka",
                                                  "Nezabudni sa pomodliť.",
                                                  time);
                                          await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    title: Text(
                                                      "Večerná pripomienka",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Tvoja večerná pripomienka je nastavená na ${notification["evening_time"]}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, "Ok");
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        }
                                        setState(() {
                                          notification["evening"] = value;
                                        });

                                        await _save
                                            .saveNotification(notification);
                                      },
                                      activeColor: Color(0xFFE4C103),
                                      activeTrackColor: Color(0xFF5F5000),
                                      inactiveTrackColor: Color(0x61FFFFFF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
            getPart(title: "Všeobecné informácie", body: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Verzia:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "1.0.0",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Autori:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Samuel Vašečka",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Michal Kyselica",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }
}
