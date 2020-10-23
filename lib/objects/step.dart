import 'package:oaza/functions/save.dart';

class AllSteps {
  static AllSteps _self = null;
  static getInstance() {
    if (_self == null) {
      _self = AllSteps();
    }
    return _self;
  }

  // Zoznam všetkých krokov
  List<Step> steps = [];

  void setSteps(List<Step> list) {
    this.steps = list;
  }

  void addStep(Step step) {
    bool isHere = false;
    for (int i = 0; i < steps.length; i++) {
      if (steps[i].getStepId() == step.getStepId()) {
        steps[i] = step;
        isHere = true;
        break;
      }
    }
    if (isHere == false) {
      this.steps.add(step);
    }
  }

  Day getActualDay() {
    DateTime dateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (int i = 0; i < this.steps.length; i++) {
      for (int j = 0; j < this.steps[i].days.length; j++) {
        if (this.steps[i].days[j].dateTime == dateTime) {
          return this.steps[i].days[j];
        }
      }
    }

    if (dateTime.weekday == 7) {
      return Day(
          step: -1,
          id: -2,
          partA:
              "Dnes si prečítaj liturgické čítania z dnešného dňa. |https://lc.kbs.sk/");
    } else {
      return Day(
          step: -1,
          id: -1,
          partA:
              "Dnes sa pomodli modlitbu z breviára. |https://lh.kbs.sk/default.htm");
    }
  }

  void setStep(int index, Step step) {
    this.steps[index - 1] = step;
  }

  // Sort na zoradenie krokov podľa poradia
  void sortSteps() {
    steps.sort((a, b) => a.getStepId().compareTo(b.getStepId()));
  }

  // Getter na Krok podľa indexu
  Step getStep(int index) {
    return steps[index - 1];
  }

  // Kontrola ci je dany krok stiahnuty
  bool getStepCheck(int index) {
    try {
      if (steps[index - 1] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Map toJson() {
    Map map = {"steps": []};
    for (int i = 0; i < steps.length; i++) {
      map["steps"].add(steps[i].toJson());
    }
    return map;
  }
}

class Step {
  // Názov kroku
  String title;
  // Smerovka kroku
  String signPost;
  // Poradové číslo kroku
  int id;
  // Zoznam dní v kroku
  List<Day> days;
  // Datum stiahnuta
  String date;

  String quote;

  Step({
    this.title,
    this.signPost,
    this.id,
    this.days,
    this.date,
    this.quote,
  });

  // Getter na deň podľa indexu
  Day getDay(int index) {
    return days[index - 1];
  }

  void addDay(Day day) {
    bool isHere = false;
    for (int i = 0; i < days.length; i++) {
      if (days[i].getDayId() == day.getDayId()) {
        days[i] = day;
        isHere = true;
        break;
      }
    }
    if (isHere == false) {
      this.days.add(day);
    }
  }

  // Getter na všetky dni
  List<Day> getDays() {
    return days;
  }

  // Getter na poradové číslo kroku
  int getStepId() {
    return id;
  }

  String getDate() {
    return date;
  }

  void sortDays() {
    days.sort((a, b) => a.getDayId().compareTo(b.getDayId()));
  }

  Map toJson() {
    Map map = {
      "title": this.title,
      "sign_post": this.signPost,
      "id": this.id,
      "date": this.date,
      "days": [],
      "quote": this.quote,
    };
    for (int i = 0; i < days.length; i++) {
      map["days"].add(days[i].toJson());
    }
    return map;
  }
}

class Day {
  int step;
  // Poradové číslo dňa
  int id;
  // Text prvej časti dňa
  String partA;
  // Text druhej časti dňa
  String partB;
  // Text tretej časti dňa
  String partC;

  DateTime dateTime;

  int week;

  Day({
    this.step,
    this.id,
    this.partA,
    this.partB,
    this.partC,
    this.week,
    this.dateTime,
  });

  // Getter na poradové číslo dňa
  int getDayId() {
    return this.id;
  }

  // Getter na text prvej časti dňa
  String getPartA() {
    return this.partA;
  }

  // Getter na text druhej časti dňa
  String getPartB() {
    return this.partB;
  }

  // Getter na text tretej časti dňa
  String getPartC() {
    return this.partC;
  }

  int getWeek() {
    return this.week;
  }

  void setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  Map toJson() {
    return {
      "step": this.step,
      "id": this.id,
      "part_a": this.partA,
      "part_b": this.partB,
      "part_c": this.partC,
      "week": this.week,
      "date_time": "${this.dateTime}",
    };
  }
}
