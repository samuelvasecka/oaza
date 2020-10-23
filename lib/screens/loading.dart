import 'package:flutter/material.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/screens/home.dart';
import 'package:oaza/screens/login.dart';
import 'package:oaza/functions/api.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Save _save = Save();
  Profile _profile = Profile.getInstance();
  Api _api;

  bool _done = false;
  bool _limitDone = false;

  Future<void> _limit() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _limitDone = true;
      if (_done) {
        _done = false;
        _limitDone = false;
        print(_profile.toJson());
        if (_profile.loggedIn == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home(null)));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage(null)));
        }
      }
    });
  }

  Future<void> _loadData() async {
    await _save.loadProfile();
    //if (_profile.actualStepDay["started"]) {
    //      DateTime day = _profile.actualStepDay["start_date"]
    //      if (day.day == DateTime.now().day && day.month == DateTime.now().month && day.year == DateTime.now().year) {
    //
    //      } else if (day.month == DateTime.now().month && day.year == DateTime.now().year) {
    //
    //      }
    //    }
    await _save.loadSteps();
    if (_profile.loggedIn == true) {
      if (await _api.checkInternetConnection()) {
        await _api.userLogin(
            email: _profile.email, password: _profile.password);
      }
    }

    setState(() {
      _done = true;
      if (_limitDone) {
        _done = false;
        _limitDone = false;
        print(_profile.toJson());
        if (_profile.loggedIn) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home(null)));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage(null)));
        }
      }
    });
  }

  @override
  void initState() {
    _loadData();
    _limit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_api == null) {
      _api = Api(context: context);
    }
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}
