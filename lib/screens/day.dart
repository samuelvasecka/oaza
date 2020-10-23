import 'package:flutter/material.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/objects/step.dart';
import 'package:oaza/functions/api.dart';
import 'package:oaza/functions/save.dart';
import 'package:intl/intl.dart';
import 'package:oaza/objects/step.dart' as step;
import 'package:url_launcher/url_launcher.dart';

enum Types { NORMAl, SUNDAY, NOT_DEF, SHOW_STEP }

class DayPage extends StatefulWidget {
  int actualStep;
  int actualDay;
  String name;
  step.Day day;

  DayPage({this.actualStep, this.actualDay, this.name, this.day});
  @override
  _DayPageState createState() => _DayPageState(
      actualStep: this.actualStep,
      actualDay: this.actualDay,
      name: this.name,
      day: this.day);
}

class _DayPageState extends State<DayPage> {
  int actualStep;
  int actualDay;
  String name;
  step.Day day;
  Types type;
  _DayPageState({this.actualStep, this.actualDay, this.name, this.day}) {
    if (this.day.id == -2) {
      type = Types.SUNDAY;
      actualDay = 1;
    } else if (this.day.id == -1) {
      type = Types.NOT_DEF;
      actualDay = 1;
    } else {
      if (actualStep == day.step) {
        type = Types.NORMAl;
        actualStep = day.step;
        actualDay = day.id;
      } else if (actualStep == -1) {
        type = Types.NOT_DEF;
        actualStep = 1;
      } else {
        type = Types.NOT_DEF;
      }
    }
  }

  Profile _profile = Profile.getInstance();
  AllSteps _allSteps = AllSteps.getInstance();
  Save _save = Save();
  Api _api;
  String part = "part_a";
  bool downloaded = false;
  bool _showSpinner = false;
  bool zoom = false;
  bool _showActualization = false;

  List<Widget> getContent() {
    if (type == Types.NORMAl) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 37, 0, 0),
          child: Center(
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (actualDay != 1) {
                    setState(() {
                      actualDay--;
                    });
                  }
                },
              ),
              Text(
                "$actualDay. deň",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_allSteps.getStep(actualStep).days.length > actualDay) {
                    setState(() {
                      actualDay++;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    part = "part_a";
                  });
                },
                child: Text(
                  'RÁNO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: this.part == "part_a"
                    ? Color(0xFFFFB100)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    part = "part_b";
                  });
                },
                child: Text(
                  'STÁNOK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: this.part == "part_b"
                    ? Color(0xFFFFB100)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    part = "part_c";
                  });
                },
                child: Text(
                  'VEČER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: this.part == "part_c"
                    ? Color(0xFFFFB100)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    part = "part_d";
                  });
                },
                child: Text(
                  'SMEROVKA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: this.part == "part_d"
                    ? Color(0xFFFFB100)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    part = "part_e";
                  });
                },
                child: Text(
                  'CITÁT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: this.part == "part_e"
                    ? Color(0xFFFFB100)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 34, 0, 0),
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                zoom = true;
              });
            },
            child: Text(
              actualDay == -1 || actualDay == -2
                  ? ""
                  : this.part == "part_a"
                      ? "Ranná modlitba"
                      : this.part == "part_b"
                          ? "Stánok stretnutia"
                          : this.part == "part_c"
                              ? "Večerná modlitba"
                              : this.part == "part_d"
                                  ? "Smerovka nového človeka"
                                  : "Nauč sa naspamäť",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                zoom = true;
              });
            },
            child: Text(
              actualDay == -1 || actualDay == -2
                  ? ""
                  : this.part == "part_a"
                      ? _allSteps.getStep(actualStep).getDay(actualDay).partA
                      : this.part == "part_b"
                          ? _allSteps
                              .getStep(actualStep)
                              .getDay(actualDay)
                              .partB
                          : this.part == "part_c"
                              ? _allSteps
                                  .getStep(actualStep)
                                  .getDay(actualDay)
                                  .partC
                              : this.part == "part_d"
                                  ? _allSteps.getStep(actualStep).signPost
                                  : _allSteps.getStep(actualStep).quote,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ];
    } else if (type == Types.SUNDAY) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 37, 0, 0),
          child: Center(
            child: Text(
              "Nedeľa",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 46, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.partA.split("|")[0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () async {
                  if (await canLaunch(day.partA.split("|")[1])) {
                    await launch(day.partA.split("|")[1]);
                  }
                },
                child: Text(
                  day.partA.split("|")[1],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 37, 0, 0),
          child: Center(
            child: Text(
              "Voľný deň",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 46, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.partA.split("|")[0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () async {
                  if (await canLaunch(day.partA.split("|")[1])) {
                    await launch(day.partA.split("|")[1]);
                  }
                },
                child: Text(
                  day.partA.split("|")[1],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ];
    }
  }

  List<Widget> getNotDownload() {
    if (downloaded) {
      return [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE7C401)),
          backgroundColor: Colors.transparent,
        )
      ];
    } else {
      return [
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 6 * 3.2,
          color: Color(0xFFFFB100),
          child: Text(
            "STIAHNUŤ KROK",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            setState(() {
              _showSpinner = true;
            });
            await _api.downloadStepData(actualStep);
            setState(() {
              _showSpinner = false;
              _allSteps = AllSteps.getInstance();
            });
          },
        ),
      ];
    }
  }

  Future<void> downloadStepActualization() async {
    if (await _api.checkInternetConnection()) {
      if (await _api.downloadDate(actualStep)) {
        setState(() {
          _showActualization = true;
        });
        if (await _api.downloadStepData(actualStep) == false) {
          setState(() {
            downloaded = false;
          });
        } else {
          setState(() {
            _allSteps = AllSteps.getInstance();
          });
        }
        setState(() {
          _showActualization = false;
        });
      } else {
        setState(() {
          downloaded = false;
        });
      }
    } else {
      setState(() {
        downloaded = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_api == null) {
      _api = Api(context: context);
      //downloadStepActualization();
    }
    return Scaffold(
        floatingActionButton:
            _profile.roles.contains("animator") && zoom == false
                ? FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Color(0xFFFFB100),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      int value = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  "Začať krok $actualStep",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Text(
                                  "Ktorú časť kroku chceš začať?",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text(
                                      "Prvú",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, 1);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Druhú",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, 2);
                                    },
                                  )
                                ],
                              ));
                      if (value != null) {
                        DateTime date = await showDatePicker(
                          cancelText: "Zrušiť",
                          helpText:
                              "Vyber dátum, kedy má začať $value. časť kroku.",
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
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
                        if (date != null) {
                          setState(() {
                            _showSpinner = true;
                          });
                          await _api.downloadStepsDates();
                          await _api.setStepsDates(actualStep, value, date);
                          await _api.downloadStepsDates();
                          setState(() {
                            _showSpinner = false;
                          });
                          Navigator.pop(context);
                        }
                      }
                    },
                  )
                : null,
        appBar: zoom
            ? null
            : AppBar(
                elevation: 0,
                title: type == Types.NOT_DEF || type == Types.SUNDAY
                    ? _allSteps.getStepCheck(actualStep) == false
                        ? Text("$actualStep. KROK")
                        : null
                    : Text("$actualStep. KROK"),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, "ok");
                  },
                ),
                actions: [
                  _showActualization
                      ? Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Center(
                            child: Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFE7C401)),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  type == Types.NORMAl
                      ? Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Center(
                            child: Text(
                              _allSteps.getStepCheck(actualStep)
                                  ? _allSteps
                                              .getStep(actualStep)
                                              .getDay(actualDay)
                                              .dateTime ==
                                          null
                                      ? ""
                                      : _allSteps.getStepCheck(actualStep)
                                          ? DateFormat("dd.MM.yyyy")
                                              .format(_allSteps
                                                  .getStep(actualStep)
                                                  .getDay(actualDay)
                                                  .dateTime)
                                              .toString()
                                          : ""
                                  : "",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : _allSteps.getStepCheck(actualStep) == false
                          ? SizedBox()
                          : Center(
                              child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  type = Types.NORMAl;
                                });
                              },
                            ))
                ],
                automaticallyImplyLeading: false,
              ),
        body: _showSpinner
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE7C401)),
                  backgroundColor: Colors.transparent,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _allSteps.getStepCheck(actualStep)
                    ? zoom
                        ? SafeArea(
                            child: GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  zoom = false;
                                });
                              },
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 56, 0, 0),
                                    child: Text(
                                      this.part == "part_a"
                                          ? _allSteps
                                              .getStep(actualStep)
                                              .getDay(actualDay)
                                              .partA
                                          : this.part == "part_b"
                                              ? _allSteps
                                                  .getStep(actualStep)
                                                  .getDay(actualDay)
                                                  .partB
                                              : this.part == "part_c"
                                                  ? _allSteps
                                                      .getStep(actualStep)
                                                      .getDay(actualDay)
                                                      .partC
                                                  : this.part == "part_d"
                                                      ? _allSteps
                                                          .getStep(actualStep)
                                                          .signPost
                                                      : _allSteps
                                                          .getStep(actualStep)
                                                          .quote,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            children: getContent(),
                          )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getNotDownload(),
                        ),
                      )));
  }
}
