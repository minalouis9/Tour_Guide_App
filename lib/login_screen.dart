import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'googleMap_screen.dart';
import './forgetPassword_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Color(0xffF2CE1B));
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _successfulSingUp = false;

  void initState() {
    super.initState();
    _successfulSignUpOccurred();
  }

  void _successfulSignUpOccurred() async {
    final prefs = await SharedPreferences.getInstance();
    final signUpOccurred = prefs.getBool("successfulSignUp");

    setState(() {
      if(signUpOccurred != null) {
        _successfulSingUp = signUpOccurred;
      }
      else {
        _successfulSingUp = false;
      }

    });
  }

  void _setSuccessfulSignUp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("successfulSignUp", value);

    setState(() {
      _successfulSingUp = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Future<FirebaseUser> _regularLoginIn() async {
      await _auth.signOut();
      //_googleSignIn.signOut();

      final prefs = await SharedPreferences.getInstance();
      FirebaseUser user;

      try{
        user = await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
      } catch (e) {
        print('Error');
      }

      if(user != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .getDocuments();

        final List<DocumentSnapshot> documents = result.documents;

        if (documents.length != 0) {
          // Update data to server if new user
          prefs.setString("userName", (documents[0].data['firstName'] + " " + documents[0].data['lastName']));
          prefs.setString("mobileNumber", documents[0].data['mobileNumber']);
          prefs.setString("email", documents[0].data['email']);
          prefs.setString("password", documents[0].data['password']);
          prefs.setString("city", documents[0].data['city']);
          prefs.setString("country", documents[0].data['country']);
        }
        Navigator.pushAndRemoveUntil(context, GoogleMapScreenRoute(), ModalRoute.withName("maps"));
      }
      return user;
    }

    Future<FirebaseUser> _googleLoginIn() async {
      //await _auth.signOut();
      _googleSignIn.signOut();

      final prefs = await SharedPreferences.getInstance();
      FirebaseUser user;

      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try{
        user = await _auth.signInWithCredential(credential);
      } catch (e) {
        print('Error');
      }

      if(user != null) {
        Navigator.pushAndRemoveUntil(context, GoogleMapScreenRoute(), ModalRoute.withName("maps"));
      }
      return user;
    }

    final emailField = TextField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      style: style,
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
        obscureText: true,
        style: style,
        maxLines: 1,
        controller: _password,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Password",
          hintStyle: TextStyle(color: Color(0xffF2CE1B)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Color(0xffF2CE1B), width: 1.0)),
        )
    );

    final forgetPassword = InkWell(
      child: Text(
        'Forgot your password ?',
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 12, fontStyle: FontStyle.italic),
      ),
      onTap: () {
        Navigator.of(context).push(new ForgetPasswordScreenRoute());
      },
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          _regularLoginIn();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    final googleLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          onPressed: () {
            _googleLoginIn();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/google.png",
                width: 30,
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              Text("   Sign In with Google",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          )),
    );

    final facebookLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffF2CE1B),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/facebook.png",
                width: 30,
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              Text("   Sign In with Facebook",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          )),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 100.0, 36.0, 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        height: 130.0,
                        child: Image.asset(
                          "assets/logo7.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        "The journey is the destination",
                        style: TextStyle(
                            fontFamily: 'Titillium',
                            fontSize: 13,
                            color: Color(0xffF2CE1B)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 80.0),
                      emailField,
                      SizedBox(height: 10.0),
                      passwordField,
                      SizedBox(
                        height: 10.0,
                      ),
                      forgetPassword,
                      SizedBox(
                        height: 100.0,
                      ),
                      loginButton,
                      SizedBox(height: 10.0,),
                      googleLoginButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child:  _successfulSingUp ?
            AlertDialog(
              elevation: 5.0,
              content: Text("Signed Up successfully please Login ..."),
              backgroundColor: Colors.yellow,
              actions: <Widget>[
                MaterialButton(
                  child: Text("Ok"),
                  onPressed: (){
                    _setSuccessfulSignUp(false);
                  },
                )
              ],
            )
                :
            SizedBox(),
          )
        ],
      ),
    );
  }
}

class ForgetPasswordScreenRoute extends CupertinoPageRoute {
  ForgetPasswordScreenRoute()
      : super(builder: (BuildContext context) => new ForgetPassword());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new ForgetPassword());
  }
}

class GoogleMapScreenRoute extends CupertinoPageRoute {
  GoogleMapScreenRoute()
      : super(builder: (BuildContext context) => new MapSample());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new MapSample());
  }
}