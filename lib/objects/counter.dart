import 'package:oaza/objects/step.dart';

class Counter {
  static AllSteps setDaysDates(Map stepsDates, AllSteps allSteps) {
    for (int i = 1; i <= 10; i++) {
      DateTime dateTime1;
      try {
        dateTime1 = DateTime.parse(stepsDates["step_$i"]["part_1"]);
        print("dateTime1: $dateTime1");
      } catch (e) {
        dateTime1 = null;
      }

      DateTime dateTime2;
      try {
        dateTime2 = DateTime.parse(stepsDates["step_$i"]["part_2"]);
        print("dateTime2: $dateTime2");
      } catch (e) {
        dateTime2 = null;
      }

      if (allSteps.getStepCheck(i)) {
        for (int j = 1; j <= allSteps.getStep(i).days.length; j++) {
          if (allSteps.getStep(i).getDay(j).week == 2) {
            if (dateTime2 != null) {
              if (dateTime2.weekday != 7) {
                allSteps.getStep(i).getDay(j).setDateTime(dateTime2);
                dateTime2 = dateTime2.add(Duration(days: 1));
              } else {
                dateTime2 = dateTime2.add(Duration(days: 1));
                allSteps.getStep(i).getDay(j).setDateTime(dateTime2);
                dateTime2 = dateTime2.add(Duration(days: 1));
              }
            }
          } else {
            if (dateTime1 != null) {
              if (dateTime1.weekday != 7) {
                allSteps.getStep(i).getDay(j).setDateTime(dateTime1);
                dateTime1 = dateTime1.add(Duration(days: 1));
              } else {
                dateTime1 = dateTime1.add(Duration(days: 1));
                allSteps.getStep(i).getDay(j).setDateTime(dateTime1);
                dateTime1 = dateTime1.add(Duration(days: 1));
              }
            }
          }
        }
      }
    }
    return allSteps;
  }
}
