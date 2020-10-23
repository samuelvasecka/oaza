import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oaza/objects/profile.dart';
import 'package:oaza/objects/language.dart';
import 'dart:convert';
import 'package:oaza/objects/step.dart' as steps;
import 'package:oaza/functions/save.dart';
import 'package:oaza/objects/counter.dart';
import 'dart:convert';

class Api {
  BuildContext context;
  Api({this.context});

  Profile _profile = Profile.getInstance();
  steps.AllSteps allSteps = steps.AllSteps.getInstance();
  Save _save = Save();

  static const String _usersTableName = "users";
  static const String _usersDatabaseCode = "appO1vezkumVHlm2T";
  static const String _groupsTableName = "groups";
  static const String _groupsDatabaseCode = "appa0ke25J7Hs9xFg";
  static const String _stepsTableName = "steps";
  static const String _stepsDatabaseCode = "appNGK6d4pWMYnioA";
  static const String _stepDaysTableName = "step_days";
  static const String _stepDaysDatabaseCode = "appVchvsKfXo0svOk";

  static const String _apiKey = "keyejHPFoU7JySl1Q";

  // Error dialog
  Future<void> showErrorDialog(String errorText) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                Language.getWord("error"),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Text(
                errorText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    Language.getWord("ok"),
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
  }

  // Dialog
  Future<void> _showSuccessDialog(String successText) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                Language.getWord("great"),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Text(
                successText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    Language.getWord("ok"),
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
  }

  // Kontrola internetového pripojenia
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  // Kontrola či je zadaná hodnota prázdna
  bool _emptyValue(String value) {
    if (value == null || value == "") {
      return true;
    } else {
      return false;
    }
  }

  // Vyhľadávanie v AirTable pomocou kľúča a hodnoty
  Future<bool> _findInAirTable(
      {String value, String key, String table, String database}) async {
    http.Response response = await http.get(
      'https://api.airtable.com/v0/$database/$table?filterByFormula={$key}=%22$value%22&api_key=$_apiKey',
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['records'].length == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      await showErrorDialog(Language.getWord("something_went_wrong"));
      return false;
    }
  }

  // Registrácia používteľa
  Future<bool> userRegistration(
      {String fullName, String groupId, String email, String password}) async {
    if (_emptyValue(fullName) ||
        _emptyValue(groupId) ||
        _emptyValue(email) ||
        _emptyValue(password)) {
      await showErrorDialog(Language.getWord("all_fields_are_required"));
      return false;
    }

    if (await checkInternetConnection()) {
      if (await _findInAirTable(
            value: email,
            key: "email",
            table: _usersTableName,
            database: _usersDatabaseCode,
          ) ==
          false) {
        await showErrorDialog(
            Language.getWord("unsuccessful_registration_email"));
        return false;
      }

      if (await _findInAirTable(
        value: groupId,
        key: "group_id",
        table: _groupsTableName,
        database: _groupsDatabaseCode,
      )) {
        await showErrorDialog(
            Language.getWord("unsuccessful_registration_group_id"));
        return false;
      }

      Map<String, String> headers = {"Content-type": "application/json"};
      String body =
          '{"records": [{"fields": {"email":"$email", "password": "$password", "full_name": "$fullName", "group_id": "$groupId", "role": "participant"}}],"typecast": true}';

      http.Response response = await http.post(
          "https://api.airtable.com/v0/$_usersDatabaseCode/$_usersTableName?api_key=$_apiKey",
          body: body,
          headers: headers);
      if (response.statusCode == 200) {
        await _showSuccessDialog(Language.getWord("successful_registration"));
        _profile.setName(fullName);
        _profile.setGroupId(groupId);
        _profile.setPassword(password);
        _profile.setRoles(["participant"]);
        _profile.setLoggedIn(true);
        _profile.setStepsStart({});
        _profile.setEmail(email);
        _profile.setActualStepDay({
          "step": 1,
          "day": 1,
          "started": false,
          "start_date": null,
        });
        await _save.saveProfile(_profile.toJson());
        return true;
      } else {
        await showErrorDialog(Language.getWord("something_went_wrong"));
        return false;
      }
    } else {
      await showErrorDialog(Language.getWord("no_internet"));
      return false;
    }
  }

  // Prihlásenie používateľa
  Future<bool> userLogin({String email, String password}) async {
    if (_emptyValue(email) || _emptyValue(password)) {
      await showErrorDialog(Language.getWord("unsuccessful_login"));
      return false;
    }

    if (await checkInternetConnection()) {
      http.Response response;
      response = await http.get(
          'https://api.airtable.com/v0/$_usersDatabaseCode/$_usersTableName?filterByFormula={email}=%22$email%22&api_key=$_apiKey');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['records'].length != 0) {
          if (data['records'][0]['fields']['password'] == password) {
            _profile.setName(data['records'][0]['fields']['full_name']);
            _profile.setGroupId(data['records'][0]['fields']['group_id']);
            _profile.setRoles(data["records"][0]["fields"]["role"]);
            _profile.setEmail(data["records"][0]["fields"]["email"]);
            _profile.setLoggedIn(true);
            _profile.setPassword(data['records'][0]['fields']['password']);
            _profile.setStepsStart({});
            if (_profile.actualStepDay == {} || _profile.loggedIn == false) {
              _profile.setActualStepDay({
                "step": 1,
                "day": 1,
                "started": false,
                "start_date": null,
              });
            }

            await _save.saveProfile(_profile.toJson());
            return true;
          } else {
            await showErrorDialog(Language.getWord("unsuccessful_login"));
            return false;
          }
        } else {
          await showErrorDialog(Language.getWord("unsuccessful_login"));
          return false;
        }
      } else {
        await showErrorDialog(Language.getWord("something_went_wrong"));
        return false;
      }
    } else {
      await showErrorDialog(Language.getWord("no_internet"));
      return false;
    }
  }

  Future<bool> downloadStepData(int actualStep) async {
    if (await checkInternetConnection()) {
      http.Response response = await http.get(
          "https://api.airtable.com/v0/$_stepsDatabaseCode/$_stepsTableName?view=active&api_key=$_apiKey");
      if (response.statusCode == 200) {
        print(response.request);
        var data = jsonDecode(response.body);
        try {
          steps.Step step = new steps.Step(
            title: data["records"][actualStep - 1]["fields"]["title"],
            signPost: data["records"][actualStep - 1]["fields"]["sign_post"],
            id: data["records"][actualStep - 1]["fields"]["step"],
            date: data["records"][actualStep - 1]["fields"]["modified_time"],
            days: [],
            quote: data["records"][actualStep - 1]["fields"]["quote"],
          );
          http.Response responseDays = await http.get(
              "https://api.airtable.com/v0/$_stepDaysDatabaseCode/$_stepDaysTableName?filterByFormula={step}=%22$actualStep%22&view=sort_view&api_key=$_apiKey");
          if (responseDays.statusCode == 200) {
            var dataDays = jsonDecode(responseDays.body);
            for (int j = 0; j < dataDays["records"].length; j++) {
              step.addDay(steps.Day(
                step: dataDays["records"][j]["fields"]["step"],
                id: dataDays["records"][j]["fields"]["day"],
                partA: dataDays["records"][j]["fields"]["part_a"],
                partB: dataDays["records"][j]["fields"]["part_b"],
                partC: dataDays["records"][j]["fields"]["part_c"],
                week: dataDays["records"][j]["fields"]["week"],
              ));
            }
            step.sortDays();
            allSteps.addStep(step);
          }
          allSteps.sortSteps();
          allSteps = Counter.setDaysDates(
              jsonDecode(_profile.stepsStart["records"][0]["fields"]
                  ["steps_start_date"]),
              allSteps);
          _save.saveSteps(allSteps.toJson());
          return true;
        } catch (e) {
          await showErrorDialog("Tento krok zatiaľ nie je možné stiahnuť.");
          return false;
        }
      } else {
        await showErrorDialog(Language.getWord("something_went_wrong"));
        return false;
      }
    } else {
      await showErrorDialog(Language.getWord("no_internet"));
      return false;
    }
  }

  Future<bool> downloadDate(int actualStep) async {
    http.Response response = await http.get(
        "https://api.airtable.com/v0/$_stepsDatabaseCode/$_stepsTableName?filterByFormula={step}=%22$actualStep%22&view=active&api_key=$_apiKey");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.request);
      try {
        if (allSteps.getStepCheck(actualStep)) {
          if (data["records"][actualStep - 1]["fields"]["modified_time"] !=
              allSteps.getStep(actualStep).getDate()) {
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> downloadStepsData() async {
    if (await checkInternetConnection()) {
      http.Response response = await http.get(
          "https://api.airtable.com/v0/$_stepsDatabaseCode/$_stepsTableName?view=active&api_key=$_apiKey");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data["records"].length; i++) {
          steps.Step step = new steps.Step(
            title: data["records"][i]["fields"]["title"],
            signPost: data["records"][i]["fields"]["sign_post"],
            id: data["records"][i]["fields"]["step"],
            date: data["records"][i]["fields"]["modified_time"],
            days: [],
            quote: data["records"][i]["fields"]["quote"],
          );
          int index = i + 1;
          http.Response responseDays = await http.get(
              "https://api.airtable.com/v0/$_stepDaysDatabaseCode/$_stepDaysTableName?filterByFormula={step}=%22$index%22&view=sort_view&api_key=$_apiKey");
          if (responseDays.statusCode == 200) {
            var dataDays = jsonDecode(responseDays.body);
            for (int j = 0; j < dataDays["records"].length; j++) {
              step.addDay(steps.Day(
                step: dataDays["records"][j]["fields"]["step"],
                id: dataDays["records"][j]["fields"]["day"],
                partA: dataDays["records"][j]["fields"]["part_a"],
                partB: dataDays["records"][j]["fields"]["part_b"],
                partC: dataDays["records"][j]["fields"]["part_c"],
                week: dataDays["records"][j]["fields"]["week"],
              ));
            }
            step.sortDays();
            allSteps.addStep(step);
          }
        }
        allSteps.sortSteps();
        return true;
      } else {
        await showErrorDialog(Language.getWord("something_went_wrong"));
        return false;
      }
    } else {
      await showErrorDialog(Language.getWord("no_internet"));
      return false;
    }
  }

  Map findEvent(Map eventsSaved, Map event, Map events) {
    //eventsSaved["events"].forEach((item) {
    //      if (event["name"] == item["name"] && event["date"] == item["date"]) {
    //        events["events"].add(item);
    //        return events;
    //      }
    //    });

    for (int i = 0; i < eventsSaved["events"].length; i++) {
      if (event["name"] == eventsSaved["events"][i]["name"] &&
          event["date"] == eventsSaved["events"][i]["date"]) {
        events["events"].add(eventsSaved["events"][i]);
        return events;
      }
    }

    events["events"].add(event);
    return events;
  }

  Future<Map> downloadEvents() async {
    if (await checkInternetConnection()) {
      http.Response response = await http.get(
          "https://api.airtable.com/v0/appwo9MK9JXECPsQ9/events?view=sorted&api_key=$_apiKey");
      if (response.statusCode == 200) {
        Map eventsSaved = await _save.loadEvents();
        var data = jsonDecode(response.body);
        Map events = {"events": [], "error": 0};
        for (int i = 0; i < data["records"].length; i++) {
          Map event = {
            "name": data["records"][i]["fields"]["name"],
            "date": data["records"][i]["fields"]["date"],
            "place": data["records"][i]["fields"]["place"],
            "description": data["records"][i]["fields"]["description"],
            "code": data["records"][i]["fields"]["code"],
            "alarm": false,
            "alarm_time": null,
            "alarm_code": null,
          };
          //events["events"].add(event);
          events = findEvent(eventsSaved, event, events);
        }
        _save.saveEvents(events);
        return events;
      } else {
        return {"events": [], "error": 1};
      }
    } else {
      return {"events": [], "error": 2};
    }
  }

  Future<bool> downloadStepsDates() async {
    if (await checkInternetConnection()) {
      http.Response response = await http.get(
          "https://api.airtable.com/v0/appa0ke25J7Hs9xFg/groups?filterByFormula={group_id}=%22${_profile.groupId}%22&api_key=$_apiKey");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _profile.setStepsStart(data);
        allSteps = Counter.setDaysDates(
            jsonDecode(_profile.stepsStart["records"][0]["fields"]
                ["steps_start_date"]),
            allSteps);
        await _save.saveProfile(_profile.toJson());
        await _save.saveSteps(allSteps.toJson());
        return true;
      } else {
        allSteps = Counter.setDaysDates(
            jsonDecode(_profile.stepsStart["records"][0]["fields"]
                ["steps_start_date"]),
            allSteps);
        await _save.saveSteps(allSteps.toJson());
        return false;
      }
    } else {
      allSteps = Counter.setDaysDates(
          jsonDecode(
              _profile.stepsStart["records"][0]["fields"]["steps_start_date"]),
          allSteps);
      await _save.saveSteps(allSteps.toJson());
      return false;
    }
  }

  Future<bool> setStepsDates(int step, int week, DateTime date) async {
    Map stepsDates = jsonDecode(
        _profile.stepsStart["records"][0]["fields"]["steps_start_date"]);
    stepsDates["step_$step"]["part_$week"] = "$date";
    for (int i = 1; i <= 10; i++) {
      if (step == i) {
        stepsDates["step_$i"]["active"] = true;
      } else {
        stepsDates["step_$i"]["active"] = false;
      }
    }

    print(stepsDates);

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $_apiKey",
    };
    Map body = {
      "records": [
        {
          "id": "${_profile.stepsStart["records"][0]["id"]}",
          "fields": {
            "group_id": "${_profile.groupId}",
            "steps_start_date": "${jsonEncode(stepsDates)}"
          }
        }
      ],
      "typecast": true
    };

    if (await checkInternetConnection()) {
      http.Response response = await http.patch(
          "https://api.airtable.com/v0/$_groupsDatabaseCode/$_groupsTableName?api_key=$_apiKey",
          body: jsonEncode(body),
          headers: headers);

      print(response.request);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> downloadStepDataInitial() async {
    if (await checkInternetConnection()) {
      for (int i = 1; i <= 10; i++) {
        http.Response response = await http.get(
            "https://api.airtable.com/v0/$_stepsDatabaseCode/$_stepsTableName?view=active&api_key=$_apiKey");
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          try {
            steps.Step step = new steps.Step(
              title: data["records"][i - 1]["fields"]["title"],
              signPost: data["records"][i - 1]["fields"]["sign_post"],
              id: data["records"][i - 1]["fields"]["step"],
              date: data["records"][i - 1]["fields"]["modified_time"],
              days: [],
              quote: data["records"][i - 1]["fields"]["quote"],
            );
            http.Response responseDays = await http.get(
                "https://api.airtable.com/v0/$_stepDaysDatabaseCode/$_stepDaysTableName?filterByFormula={step}=%22$i%22&view=sort_view&api_key=$_apiKey");
            if (responseDays.statusCode == 200) {
              var dataDays = jsonDecode(responseDays.body);
              for (int j = 0; j < dataDays["records"].length; j++) {
                step.addDay(steps.Day(
                  step: dataDays["records"][j]["fields"]["step"],
                  id: dataDays["records"][j]["fields"]["day"],
                  partA: dataDays["records"][j]["fields"]["part_a"],
                  partB: dataDays["records"][j]["fields"]["part_b"],
                  partC: dataDays["records"][j]["fields"]["part_c"],
                  week: dataDays["records"][j]["fields"]["week"],
                ));
              }
              step.sortDays();

              allSteps.addStep(step);
            }
            allSteps.sortSteps();
            _save.saveSteps(allSteps.toJson());
            print("ok");
            //return true;
          } catch (e) {
            print("error");
            //return false;
          }
        } else {
          print("not ok");
          //return false;
        }
      }
      await downloadStepsDates();
      return true;
    } else {
      print("not internet");
      return false;
    }
  }

  Future<bool> userLoginInitial({String email, String password}) async {
    if (_emptyValue(email) || _emptyValue(password)) {
      return false;
    }

    if (await checkInternetConnection()) {
      http.Response response;
      response = await http.get(
          'https://api.airtable.com/v0/$_usersDatabaseCode/$_usersTableName?filterByFormula={email}=%22$email%22&api_key=$_apiKey');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['records'].length != 0) {
          if (data['records'][0]['fields']['password'] == password) {
            _profile.setName(data['records'][0]['fields']['full_name']);
            _profile.setGroupId(data['records'][0]['fields']['group_id']);
            _profile.setRoles(data["records"][0]["fields"]["role"]);
            _profile.setEmail(data["records"][0]["fields"]["email"]);
            _profile.setLoggedIn(true);
            _profile.setPassword(data['records'][0]['fields']['password']);
            _profile.setStepsStart({});
            if (_profile.actualStepDay == {} || _profile.loggedIn == false) {
              _profile.setActualStepDay({
                "step": 1,
                "day": 1,
                "started": false,
                "start_date": null,
              });
            }

            await _save.saveProfile(_profile.toJson());
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
