import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oaza/objects/step.dart';
import 'package:oaza/objects/profile.dart';

class Save {
  SharedPreferences _sharedPreferences;
  AllSteps allSteps = AllSteps.getInstance();
  static const String _stepsKey = "steps_key";
  static const String _profileKey = "profile_key";
  static const String _eventsKey = "events_key";
  static const String _idKey = "id_key";
  static const String _notificationsKey = "notifications_key";

  Future<void> loadSteps() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String allStepsString = _sharedPreferences.getString(_stepsKey) ?? "";

    if (allStepsString == "") {
      allSteps.setSteps([]);
    } else {
      allSteps.setSteps([]);
      Map allStepsMap = jsonDecode(allStepsString);
      print(allStepsMap["steps"][0]["days"].length);
      for (int i = 0; i < allStepsMap["steps"].length; i++) {
        Step step = new Step(
          title: allStepsMap["steps"][i]["title"],
          signPost: allStepsMap["steps"][i]["sign_post"],
          id: allStepsMap["steps"][i]["id"],
          date: allStepsMap["steps"][i]["date"],
          days: [],
          quote: allStepsMap["steps"][i]["quote"],
        );
        for (int j = 0; j < allStepsMap["steps"][i]["days"].length; j++) {
          DateTime dateTime;
          try {
            dateTime =
                DateTime.parse(allStepsMap["steps"][i]["days"][j]["date_time"]);
          } catch (e) {
            dateTime = null;
          }
          step.addDay(Day(
            step: allStepsMap["steps"][i]["days"][j]["step"],
            id: allStepsMap["steps"][i]["days"][j]["id"],
            partA: allStepsMap["steps"][i]["days"][j]["part_a"],
            partB: allStepsMap["steps"][i]["days"][j]["part_b"],
            partC: allStepsMap["steps"][i]["days"][j]["part_c"],
            week: allStepsMap["steps"][i]["days"][j]["week"],
            dateTime: dateTime,
          ));
        }
        allSteps.addStep(step);
      }
    }
  }

  Future<void> saveSteps(Map allStepsMap) async {
    String allStepsString = jsonEncode(allStepsMap);
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_stepsKey, allStepsString);
  }

  Future<void> loadProfile() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String profileString = _sharedPreferences.getString(_profileKey) ?? "";
    Profile profile = Profile.getInstance();
    if (profileString == "") {
      profile.setName("");
      profile.setGroupId("");
      profile.setStepsStart({});
      profile.setRoles([]);
      profile.setEmail("");
      profile.setLoggedIn(false);
      profile.setPassword("");
      profile.setActualStepDay({
        "step": 1,
        "day": 1,
        "started": false,
        "start_date": null,
      });
    } else {
      Map profileMap = jsonDecode(profileString);
      profile.setName(profileMap["full_name"]);
      profile.setGroupId(profileMap["group_id"]);
      profile.setStepsStart(profileMap["steps_start"]);
      profile.setRoles(profileMap["roles"]);
      profile.setEmail(profileMap["email"]);
      profile.setLoggedIn(profileMap["logged_in"]);
      //profile.setLoggedIn(false);
      profile.setPassword(profileMap["password"]);
      profile.setActualStepDay(profileMap["actual_step_day"]);
    }
  }

  Future<void> saveProfile(Map profile) async {
    String profileString = jsonEncode(profile);
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_profileKey, profileString);
  }

  Future<Map> loadEvents() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String eventsString = _sharedPreferences.getString(_eventsKey) ?? "";
    if (eventsString == "") {
      return {"events": [], "error": 0};
    } else {
      return jsonDecode(eventsString);
    }
  }

  Future<void> saveEvents(Map events) async {
    String eventsString = jsonEncode(events);
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_eventsKey, eventsString);
  }

  Future<int> loadId() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    int id = _sharedPreferences.getInt(_idKey) ?? 3;
    return id;
  }

  Future<void> saveId(int id) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt(_idKey, id);
  }

  Future<Map> loadNotification() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String date = _sharedPreferences.getString(_notificationsKey) ?? "";
    if (date == "") {
      return {
        "morning": false,
        "morning_time": "00:00",
        "lunch": false,
        "lunch_time": "00:00",
        "evening": false,
        "evening_time": "00:00",
        "notifications": false,
      };
    } else {
      return jsonDecode(date);
    }
  }

  Future<void> saveNotification(Map date) async {
    String dateString = jsonEncode(date);
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_notificationsKey, dateString);
  }
}
