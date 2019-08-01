import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'login_screen.dart';
import 'googleMap_screen.dart';
import 'signup_screen.dart';
import 'splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  // This widget is the root of your application.
}

class _MyAppState extends State<MyApp> {

  bool _isLogin = false;
  bool _isFirstVisit = false;

  void initState() {
    super.initState();
      setState(() {
        _getFirstVisit();
        _getLoginFromSharedPrefs();
      });
  }

  Future<void> _getFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final firstVisit = prefs.getBool("firstVisit");
    if(firstVisit == null){
      setState(() {
        _isFirstVisit = true;
      });
    }
    else {
      setState(() {
        _isFirstVisit = false;
      });
    }
  }

  Future<void> _getLoginFromSharedPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    final loginState = prefs.getBool("loginState");
    if(loginState != null) {
      setState(() {
        _isLogin = loginState;
      });
    }
    else{
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: {
        '/start': (context) => StartPage(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/spalsh': (context) => SplashScreen(),
        '/maps': (context) => MapSample()
      },
      home: _isFirstVisit
        ? SplashScreen()
          : _isLogin
          ? MapSample()
          : StartPage(),
    );
  }
}