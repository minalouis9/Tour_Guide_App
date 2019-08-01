import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'login_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  SignUp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _mobileNumber = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();

  String _date = "Date";

  bool _successfulSignUp;
  bool _hidePassword;

  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Color(0xffF2CE1B));

  int _index = 0;

  void initState() {
    super.initState();
    setState(() {
      _successfulSignUp = false;
      _hidePassword = true;
    });
  }

  Future<void> _nextScreen() async {
    setState(() {
      _index++;
    });
  }

  Future<void> _signUp() async {
    FirebaseUser user;
    final prefs = await SharedPreferences.getInstance();

    try {
      user = await _auth.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } catch (e) {
      print('Error');
    }

    if (user != null) {
      setState(() {
        _successfulSignUp = true;
        prefs.setBool("successfulSignUp", _successfulSignUp);
      });

      Firestore.instance.collection("users").document(user.uid).setData({
        'email': user.email,
        'password': _password.text,
        'mobileNumber': _mobileNumber.text,
        'city': _city.text,
        'country': _country.text,
        'dateOfBirth': _date,
        'firstName': _firstName.text,
        'lastName': _lastName.text,
      });
      Navigator.of(context).pushReplacement(LoginScreenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {

    final iconInvisible = Icon(Icons.visibility_off);
    final iconVisible = Icon(Icons.visibility);

    List<Icon> myIcons = [iconInvisible, iconVisible];

    final firstNameField = TextField(
      style: style,
      controller: _firstName,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "First Name",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final lastNameField = TextField(
      style: style,
      controller: _lastName,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Last Name",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final emailField = TextField(
      style: style,
      maxLines: 1,
      controller: _email,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Email",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final passwordField = TextField(
        obscureText: _hidePassword,
        style: style,
        controller: _password,
        maxLines: 1,
        decoration: InputDecoration(
          suffix: IconButton(
            color: Colors.yellow,
            icon: _hidePassword ? myIcons[0] : myIcons[1],
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          hintText: "Password",
          hintStyle: TextStyle(color: Color(0xffF2CE1B)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        ));

    final nextButton = Builder(builder: (BuildContext context) {
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xffF2CE1B),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          onPressed: () {
            if (_firstName.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("First name is required ..."),
                duration: Duration(seconds: 5),
              ));
            } else if (_lastName.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Last name is required ..."),
                duration: Duration(seconds: 5),
              ));
            } else if (_password.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Password must be at least 6 characters ..."),
                duration: Duration(seconds: 5),
              ));
            } else if (_email.text.isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("A valid email must be provided ..."),
                duration: Duration(seconds: 5),
              ));
            } else {
              _nextScreen();
            }
          },
          child: Text("Next",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );
    });

    final mobileNumberField = TextField(
      style: style,
      keyboardType: TextInputType.phone,
      controller: _mobileNumber,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Mobile Number",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final dateOfBirthField = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: (){
          DatePicker.showDatePicker(context,
              minTime: DateTime(1940),
              showTitleActions: true,
              onConfirm: (date) {
                setState(() {
                  _date = date.day.toString() + " / " + date.month.toString() + " / " + date.year.toString();
                });
              },
              locale: LocaleType.en);
        },
        child: Text(_date,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      )
    );

    final countryField = TextField(
      controller: _country,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Country",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final cityField = TextField(
      style: style,
      controller: _city,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "City",
        hintStyle: TextStyle(color: Color(0xffF2CE1B)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        //icon: Icon(Icons.email)
      ),
    );

    final signUpButton = Builder(builder: (BuildContext context) {
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xffF2CE1B),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          onPressed: () {
            _signUp();
          },
          child: Text("Sign Up",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );
    });

    final screen1 = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150.0,
        ),
        firstNameField,
        SizedBox(height: 15.0),
        lastNameField,
        SizedBox(
          height: 15.0,
        ),
        emailField,
        SizedBox(
          height: 15.0,
        ),
        passwordField,
        //SizedBox(height: 15.0,),
        //confirmPasswordField,
        SizedBox(height: MediaQuery.of(context).size.height - 545),
        nextButton,
      ],
    );

    final screen2 = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 150.0),
        mobileNumberField,
        SizedBox(height: 15.0),
        dateOfBirthField,
        SizedBox(height: 15.0),
        countryField,
        SizedBox(height: 15.0),
        cityField,
        SizedBox(height: MediaQuery.of(context).size.height - 545),
        signUpButton,
      ],
    );

    List<Column> _myWidgets = [screen1, screen2];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(36.0, 100.0, 36.0, 36.0),
              child: _myWidgets[_index],
            ),
          ),
        ),
      ),
    );
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
