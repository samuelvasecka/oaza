import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oaza/objects/language.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/screens/day.dart';
import 'package:oaza/screens/event.dart';
import 'package:oaza/screens/settings.dart';
import 'package:oaza/objects/step.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/functions/api.dart';
import 'package:oaza/main.dart';

class Home extends StatefulWidget {
  NavigationBloc navigationBloc;
  Home(this.navigationBloc);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselController _controller = CarouselController();
  Profile _profile = Profile.getInstance();
  AllSteps _allSteps = AllSteps.getInstance();
  Save _save = Save();
  Api _api;

  int actualStep;
  int actualDay;
  bool _showSpinner = false;
  bool _showMainSpinner = false;
  Map events = {
    "events": [],
    "error": 0,
  };

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

  bool checkDate(String date) {
    //"${events["events"][i]["date"].toString().substring(8, 10)}.${events["events"][i]["date"].toString().substring(5, 7)}.${events["events"][i]["date"].toString().substring(0, 4)}",
    DateTime dateTime = DateTime.now();
    if (dateTime.year < int.parse(date.substring(0, 4))) {
      return true;
    } else if (dateTime.year == int.parse(date.substring(0, 4)) &&
        dateTime.month < int.parse(date.substring(5, 7))) {
      return true;
    } else if (dateTime.year == int.parse(date.substring(0, 4)) &&
        dateTime.month == int.parse(date.substring(5, 7)) &&
        dateTime.day <= int.parse(date.substring(8, 10))) {
      return true;
    } else {
      return false;
    }
  }

  Widget getEvents() {
    List<Widget> children = [];
    if (events["events"].length == 0) {
      return Material(
        borderRadius: BorderRadius.circular(4),
        elevation: 0,
        color: Color(0x55000000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Container(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  "Nemáte žiadne nadchádzajúce udalosti.",
                  style: TextStyle(
                    color: Color(0xFFFFD800),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    for (int i = 0; i < events["events"].length; i++) {
      if ((events["events"][i]["code"] == _profile.groupId ||
              events["events"][i]["code"] == null ||
              events["events"][i]["code"] == "") &&
          checkDate(events["events"][i]["date"])) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            borderRadius: BorderRadius.circular(4),
            elevation: 0,
            color: Color(0x55000000),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 72) / 2 - 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            events["events"][i]["name"],
                            style: TextStyle(
                              color: Color(0xFFFFD800),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            //overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //2020-09-27T14:00:00.000Z
                          Text(
                            "${events["events"][i]["date"].toString().substring(8, 10)}.${events["events"][i]["date"].toString().substring(5, 7)}.${events["events"][i]["date"].toString().substring(0, 4)}",
                            style: TextStyle(
                              color: Color(0xFFBFBFBF),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 72) / 2 + 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/alarm.png",
                                      width: 25,
                                      height: 25,
                                      color: events["events"][i]["alarm"]
                                          ? Color(0xFFFFD800)
                                          : Color(0x55E0E0E0),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
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
                                      "${events["events"][i]["date"].toString().substring(11, 13)}:${events["events"][i]["date"].toString().substring(14, 16)}",
                                      style: TextStyle(
                                        color: Color(0xFFBFBFBF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Event(
                                                  event: events["events"][i],
                                                ))).then((value) {
                                      setState(() {});
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      }
    }
    return Column(
      children: children,
    );
  }

  Widget getDays() {
    print("aktualny krok get days: $actualStep");
    List<Widget> children = [];
    for (int i = 0;
        i <
            (_allSteps.getStepCheck(actualStep)
                ? (_allSteps.getStep(actualStep).days.length)
                : 0);
        i++) {
      children.add(Material(
        //borderRadius: BorderRadius.circular(4),
        color: i + 1 == actualDay ? Color(0xFF171717) : Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white,
              width: 0,
              style: i + 1 == actualDay ? BorderStyle.none : BorderStyle.solid),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width - (6 * 4 + 48)) / 7,
          height: (MediaQuery.of(context).size.width - (6 * 4 + 48)) / 7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${i + 1}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                i + 1 == actualDay
                    ? SizedBox(
                        height: 4,
                      )
                    : SizedBox(),
                i + 1 == actualDay
                    ? Text(
                        "DEŇ",
                        style: TextStyle(
                          color: Color(0x6CFFFFFF),
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ));
    }
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: children,
    );
  }

  void fillImageSlider() {
    imageSliders = [];
    for (int i = 1; i <= 10; i++) {
      imageSliders.add(
        GestureDetector(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DayPage(
                          actualStep: i,
                          actualDay: actualDay,
                          name: names[i - 1],
                          day: _allSteps.getActualDay(),
                        ))).then((value) {
              setState(() {
                fillImageSlider();
                checkActualDay();
              });
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  color: _allSteps.getActualDay().step == i
                      ? Color(0xFF1C1C10)
                      : Color(0xFF171717),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/krok$i.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 39.5,
                  left: 38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        names[i - 1],
                        style: TextStyle(
                          color: _allSteps.getActualDay().step == i
                              ? Color(0xFFE7C401)
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "$i. KROK",
                        style: TextStyle(
                            color: Color(0x99FFFFFF),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _allSteps.getActualDay().step == i
                    ? Positioned(
                        bottom: 6,
                        right: 6,
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFFFFD800),
                          size: 14,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      );
    }
  }

  List<Widget> imageSliders = [];

  Future<void> loadEvents() async {
    events = await _save.loadEvents();
    setState(() {
      _showSpinner = true;
    });
    Map response = await _api.downloadEvents();
    if (response["error"] == 0) {
      events = response;
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void checkActualDay() {
    if (_allSteps.getActualDay().step != -1) {
      actualStep = _allSteps.getActualDay().step;
      actualDay = _allSteps.getActualDay().id;
    } else {
      actualStep = 1;
      actualDay = 1;
    }
  }

  void openDay() {
    Day day = _allSteps.getActualDay();
    if (day.step != -1) {
      Future(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayPage(
                      actualStep: day.step,
                      actualDay: day.id,
                      name: names[day.id - 1],
                      day: day,
                    )));
      });
    }
  }

  @override
  void initState() {
    //actualStep = _profile.actualStepDay["step"];
    //actualDay = _profile.actualStepDay["day"];
    //openDay();
    checkActualDay();
    fillImageSlider();
    //loadEvents();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_allSteps.getActualDay().step != -1) {
      _controller.onReady.then((value) =>
          _controller.animateToPage(_allSteps.getActualDay().step - 1));
    } else {
      _controller.onReady.then((value) => _controller.animateToPage(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_api == null) {
      _api = Api(context: context);
      loadEvents();
    }
    return StreamBuilder<Navigation>(
        stream: widget.navigationBloc.currentNavigationIndex,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                new IconButton(
                  icon: new Image.asset(
                    'assets/book.png',
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DayPage(
                                  actualStep: actualStep,
                                  actualDay: actualDay,
                                  name: names[actualStep - 1],
                                  day: _allSteps.getActualDay(),
                                ))).then((value) {
                      setState(() {
                        fillImageSlider();
                        checkActualDay();
                      });
                    });
                  },
                ),
                SizedBox(
                  width: 6,
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SettingsPage(widget.navigationBloc)))
                        .then((value) {
                      setState(() {
                        checkActualDay();
                      });
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: () async {
                    setState(() {
                      _showMainSpinner = true;
                    });
                    await _api.userLoginInitial(
                        email: _profile.email, password: _profile.password);
                    await _api.downloadStepDataInitial();
                    events = await _api.downloadEvents();
                    setState(() {
                      _showMainSpinner = false;
                    });
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 2, 0, 2),
                      child: Text(
                        "Domov",
                        style: TextStyle(
                          fontFamily: 'Gibson',
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 35.5, 0, 0),
                      child: Container(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Dnes",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${DateTime.now().day} ${Language.getMonth("${DateTime.now().month}")}, ${DateTime.now().year}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                width: 1,
                                height: 57,
                                color: Colors.white,
                              ),
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Modlitba na dnes",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFE7C401),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5 + 14.0 + 20,
                                    ),
                                  ],
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: IconButton(
                                      icon: Image.asset(
                                        'assets/book.png',
                                        color: Color(0xFFE7C401),
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DayPage(
                                                      actualStep: actualStep,
                                                      actualDay: actualDay,
                                                      name:
                                                          names[actualStep - 1],
                                                      day: _allSteps
                                                          .getActualDay(),
                                                    ))).then((value) {
                                          setState(() {
                                            fillImageSlider();
                                            checkActualDay();
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 44.5, 0, 2),
                      child: Text(
                        "Kroky",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 157.5,
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                onPageChanged: (int value, changeReason) {
                                  setState(() {
                                    actualStep = value + 1;

                                    if (actualStep ==
                                        _allSteps.getActualDay().step) {
                                      actualDay = _allSteps.getActualDay().id;
                                      fillImageSlider();

                                      if (actualDay == -2 || actualDay == -1) {
                                        actualDay = 1;
                                      }
                                    } else {
                                      actualDay = 1;
                                    }
                                    print("aktualny krok: $actualStep");
                                  });
                                },
                                viewportFraction: 0.5,
                                disableCenter: true,
                                autoPlay: false,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              ),
                              items: imageSliders,
                            ),
                          ),
                          Positioned(
                              left: 6,
                              top: 63,
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                ),
                              )),
                          Positioned(
                            left: -4,
                            top: 54,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _controller.previousPage();
                              },
                            ),
                          ),
                          Positioned(
                              right: 6,
                              top: 63,
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                ),
                              )),
                          Positioned(
                            right: -4,
                            top: 54,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _controller.nextPage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
                      child: getDays(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 37, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "Udalosti",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _showSpinner
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFE7C401)),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.replay,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _showSpinner = true;
                                    });
                                    Map response = await _api.downloadEvents();
                                    if (response["error"] == 0) {
                                      events = response;
                                    } else if (response["error"] == 1) {
                                      await _api.showErrorDialog(
                                          Language.getWord(
                                              "something_went_wrong"));
                                    } else {
                                      await _api.showErrorDialog(
                                          Language.getWord("no_internet"));
                                    }
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  },
                                )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                      child: getEvents(),
                    ),
                  ],
                ),
                _showMainSpinner
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFE7C401)),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
        });
  }
}
