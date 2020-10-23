import 'package:flutter/material.dart';
import 'package:oaza/main.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:oaza/functions/api.dart';
import 'package:oaza/screens/home.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/main.dart';

class RegistrationPage extends StatefulWidget {
  NavigationBloc navigationBloc;
  RegistrationPage(this.navigationBloc);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  Api _api;
  Profile _profile = Profile.getInstance();
  Save _save = Save();

  int _step = 0;
  String _fullName;
  String _email;
  String _password;
  String _groupId;

  bool _showSpinner = false;

  final TextEditingController _textControllerFullName = TextEditingController();
  final TextEditingController _textControllerEmail = TextEditingController();
  final TextEditingController _textControllerPassword = TextEditingController();
  final TextEditingController _textControllerGroupId = TextEditingController();

  FocusNode focusNodeFullName = new FocusNode();
  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();
  FocusNode focusNodeGroupId = new FocusNode();

  Future<bool> registration() async {
    setState(() {
      _showSpinner = true;
    });
    return await _api.userRegistration(
      fullName: _fullName,
      groupId: _groupId,
      email: _email,
      password: _password,
    );
  }

  Future<void> updateData() async {
    await _api.downloadStepDataInitial();
  }

  List<Widget> getStep0() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
        child: Row(
          children: [
            Text(
              "Meno a priezvisko",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Material(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF2B2B2B),
        child: TextField(
          focusNode: focusNodeFullName,
          onSubmitted: (String value) {
            FocusScope.of(context).requestFocus(focusNodeEmail);
          },
          controller: _textControllerFullName,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            setState(() {
              _fullName = value;
            });
          },
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Color(0xFF3F3F3F),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 0, 8),
        child: Row(
          children: [
            Text(
              "E-mail",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Material(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF2B2B2B),
        child: TextField(
          focusNode: focusNodeEmail,
          onSubmitted: (String value) {
            setState(() {
              _step++;
              FocusScope.of(context).requestFocus(focusNodePassword);
            });
          },
          controller: _textControllerEmail,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            setState(() {
              _email = value;
            });
          },
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Color(0xFF3F3F3F),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 6 * 3.2,
          color: Color(0xFFFFB100),
          child: Text(
            "POTVRDIŤ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              _step++;
              FocusScope.of(context).requestFocus(focusNodePassword);
            });
          },
        ),
      ),
    ];
  }

  List<Widget> getStep1() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
        child: Row(
          children: [
            Text(
              "Heslo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Material(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF2B2B2B),
        child: TextField(
          focusNode: focusNodePassword,
          onSubmitted: (String value) {
            FocusScope.of(context).requestFocus(focusNodeGroupId);
          },
          controller: _textControllerPassword,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
          },
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Color(0xFF3F3F3F),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 0, 8),
        child: Row(
          children: [
            Text(
              "Kód skupiny",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Material(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF2B2B2B),
        child: TextField(
          focusNode: focusNodeGroupId,
          onSubmitted: (String value) async {
            if (await registration()) {
              await updateData();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(widget.navigationBloc)),
                  (Route<dynamic> route) => false);
            } else {
              setState(() {
                _showSpinner = false;
                _step = 0;
                _textControllerEmail.clear();
                _textControllerPassword.clear();
                _textControllerGroupId.clear();
                _textControllerFullName.clear();
                _email = null;
                _password = null;
                _fullName = null;
                _groupId = null;
                FocusScope.of(context).requestFocus(focusNodeFullName);
              });
            }
          },
          controller: _textControllerGroupId,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            setState(() {
              _groupId = value;
            });
          },
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Color(0xFF3F3F3F),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 6 * 3.2,
          color: Color(0xFFFFB100),
          child: Text(
            "REGISTROVAŤ SA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            if (await registration()) {
              await updateData();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(widget.navigationBloc)),
                  (Route<dynamic> route) => false);
            } else {
              setState(() {
                _showSpinner = false;
                _step = 0;
                _textControllerEmail.clear();
                _textControllerPassword.clear();
                _textControllerGroupId.clear();
                _textControllerFullName.clear();
                _email = null;
                _password = null;
                _fullName = null;
                _groupId = null;
                FocusScope.of(context).requestFocus(focusNodeFullName);
              });
            }
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_api == null) {
      _api = Api(context: context);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: _step == 0 ? getStep0() : getStep1(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 48, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_step == 0) {
                              _step++;
                            } else {
                              _step--;
                            }
                          });
                        },
                      ),
                      StepsIndicator(
                        selectedStep: _step,
                        nbSteps: 2,
                        lineLength: 4,
                        doneLineThickness: 0,
                        undoneLineThickness: 0,
                        doneStepColor: Colors.white70,
                        selectedStepColorOut: Colors.transparent,
                        unselectedStepColorIn: Colors.white70,
                        unselectedStepColorOut: Colors.transparent,
                        selectedStepSize: 12,
                        unselectedStepSize: 8,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_step == 0) {
                              _step++;
                            } else {
                              _step--;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          _showSpinner
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
  }
}
