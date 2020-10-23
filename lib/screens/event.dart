import 'package:flutter/material.dart';
import 'package:oaza/functions/notification.dart';
import 'dart:io';
import 'package:oaza/functions/save.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  Map event;
  Event({this.event});
  @override
  _EventState createState() => _EventState(event: this.event);
}

class _EventState extends State<Event> {
  Map event;
  _EventState({this.event});
  NotificationHandler notificationHandler = NotificationHandler();
  Save _save = Save();

  String getDay(String date) {
    //                      "${event["date"].toString().substring(8, 10)}.${event["date"].toString().substring(5, 7)}.${event["date"].toString().substring(0, 4)}  - ${event["date"].toString().substring(11, 13)}:${event["date"].toString().substring(14, 16)}",
    DateTime dateTime = new DateTime(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(5, 7)),
      int.parse(date.substring(8, 10)),
    );
    switch (dateTime.weekday) {
      case 1:
        return "Pondelok";
      case 2:
        return "Utorok";
      case 3:
        return "Streda";
      case 4:
        return "Štvrtok";
      case 5:
        return "Piatok";
      case 6:
        return "Sobota";
      case 7:
        return "Nedeľa";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                event["name"],
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
              child: Material(
                borderRadius: BorderRadius.circular(4),
                color: Color(0x55000000),
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.event,
                            color: Color(0xFFFFD800),
                          ),
                          title: Text(
                            "${event["date"].toString().substring(8, 10)}.${event["date"].toString().substring(5, 7)}.${event["date"].toString().substring(0, 4)} - ${getDay(event["date"])}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/time.png",
                            width: 25,
                            height: 25,
                            color: Color(0xFFFFD800),
                          ),
                          title: Text(
                            "${event["date"].toString().substring(11, 13)}:${event["date"].toString().substring(14, 16)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.place,
                            color: Color(0xFFFFD800),
                          ),
                          title: Text(
                            event["place"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.event_note,
                            color: Color(0xFFFFD800),
                          ),
                          title: Text(
                            event["description"] ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            event["alarm"]
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                    child: Text(
                      "Pripomienka",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox(),
            event["alarm"]
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0x55000000),
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/time.png",
                              width: 25,
                              height: 25,
                              color: Color(0xFFFFD800),
                            ),
                            title: Text(
                              event["alarm_time"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 6 * 3.2,
                    color: Color(0xFFFFB100),
                    child: Text(
                      event["alarm"]
                          ? "ZRUŠIŤ PRIPOMIENKU"
                          : "PRIDAŤ PRIPOMIENKU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Map events = await _save.loadEvents();
                      if (event["alarm"]) {
                        event = await notificationHandler
                            .turnOffNotificationByIdEvents(events, event);
                        await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    "Pripomienka zrušená",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: Text(
                                    "Tvoja pripomienka bola úspešne zrušená.",
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
                                        Navigator.pop(context, "Ok");
                                      },
                                    )
                                  ],
                                ));
                        setState(() {});
                      } else {
                        if (Platform.isIOS) {
                          notificationHandler.requestIOSPermissions();
                        }
                        DateTime dateTime = DateTime.parse(
                            event["date"].toString().replaceAll(".000Z", "Z"));
                        TimeOfDay time = await showTimePicker(
                          cancelText: "Zrušiť",
                          helpText: "Vyber čas pripomienky",
                          context: context,
                          initialTime: TimeOfDay(
                              hour: dateTime.hour, minute: dateTime.minute),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: const Color(0xFF212121),
                                accentColor: const Color(0xFF212121),
                                colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF212121)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child,
                            );
                          },
                        );
                        if (time != null) {
                          DateTime help = DateTime.parse(event["date"]
                              .toString()
                              .replaceAll(".000Z", "Z"));
                          DateTime dateTime = DateTime(
                            help.year,
                            help.month,
                            help.day,
                            time.hour,
                            time.minute,
                          );
                          event = await notificationHandler.scheduleNotification(
                              event["name"],
                              "${DateFormat("hh:mm").format(DateTime.parse(event["date"].toString().replaceAll(".000Z", "Z")))} - ${event["place"]}",
                              event,
                              events,
                              dateTime);
                          await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Text(
                                      "Pripomienka nastavená",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    content: Text(
                                      "Tvoja pripomienka bola úspešne nastavená.",
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
                                          Navigator.pop(context, "Ok");
                                        },
                                      )
                                    ],
                                  ));
                          setState(() {});
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
