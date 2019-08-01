import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signup_screen.dart';
import './login_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class StartPage extends StatefulWidget {
  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0,color: Color(0xffF2CE1B));

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          Navigator.of(context).push(new LoginScreenRoute());
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          Navigator.of(context).push(new SignUpScreenRoute());
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/pyramid1.jpg"), fit: BoxFit.cover)
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent.withOpacity(0.6),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            SystemChannels.textInput
                .invokeMethod('TextInput.hide'); //to hide keyboard
          },
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 100.0, 36.0, 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 100.0,),
                      SizedBox(
                        height: 130.0,
                        child: Image.asset(
                          "assets/logo7.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Text("The journey is the destination",style: TextStyle(fontFamily: 'Titillium',fontSize: 13,color: Color(0xffF2CE1B)),textAlign: TextAlign.left,),
                      SizedBox(height: 145.0,),
                      loginButton,
                      SizedBox(height: 10.0,),
                      signUpButton,
                    ],
                  ),
                ),
              ),
            ),
          )),
    ),
    );
  }
}

class SignUpScreenRoute extends CupertinoPageRoute {
  SignUpScreenRoute()
      : super(builder: (BuildContext context) => new SignUp());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SignUp());
  }
}

class LoginScreenRoute extends CupertinoPageRoute {
  LoginScreenRoute() : super(builder: (BuildContext context) => new Login());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new Login());
  }
}