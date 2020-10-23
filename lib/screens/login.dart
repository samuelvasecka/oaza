import 'package:flutter/material.dart';
import 'package:oaza/screens/registration.dart';
import 'package:oaza/functions/api.dart';
import 'package:oaza/screens/home.dart';
import 'package:oaza/objects/profile.dart';
import 'package:oaza/functions/save.dart';
import 'package:oaza/main.dart';

class LoginPage extends StatefulWidget {
  NavigationBloc navigationBloc;
  LoginPage(this.navigationBloc);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Api _api;
  Profile _profile = Profile.getInstance();
  Save _save = Save();

  String _email;
  String _password;

  bool _showSpinner = false;

  final TextEditingController _textControllerEmail = TextEditingController();
  final TextEditingController _textControllerPassword = TextEditingController();

  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();

  Future<bool> login() async {
    setState(() {
      _showSpinner = true;
    });
    return await _api.userLogin(
      email: _email,
      password: _password,
    );
  }

  Future<void> updateData() async {
    await _api.downloadStepDataInitial();
  }

  @override
  Widget build(BuildContext context) {
    if (_api == null) {
      _api = Api(
        context: context,
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: Row(
                    children: [
                      Text(
                        "E-mail",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                      FocusScope.of(context).requestFocus(focusNodePassword);
                    },
                    controller: _textControllerEmail,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
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
                  padding: const EdgeInsets.fromLTRB(8, 12, 0, 8),
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
                    onSubmitted: (String value) async {
                      if (await login()) {
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
                          _textControllerEmail.clear();
                          _textControllerPassword.clear();
                          _email = null;
                          _password = null;
                          FocusScope.of(context).requestFocus(focusNodeEmail);
                        });
                      }
                    },
                    controller: _textControllerPassword,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: true,
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
                      "PRIHLÁSIŤ SA",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (await login()) {
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
                          _textControllerEmail.clear();
                          _textControllerPassword.clear();
                          _email = null;
                          _password = null;
                          FocusScope.of(context).requestFocus(focusNodeEmail);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "Nemáte konto?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        "Zaregistrujte sa",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationPage(widget.navigationBloc)));
                      },
                    ),
                  ],
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
