import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  List<Text> myList = [splashText1,splashText2,splashText3];
  List<Color> myColor = [Color(0xffF2CE1B),Color(0xffF2C12E),Color(0xffF29F05)];

  int _index = 0;

  static final splashText1 = Text("You see what a tiny place you occupy in the world.",style: TextStyle(fontFamily: 'TitilliumWeb', package: 'awesome_package', fontSize: 40.0));
  static final splashText2 = Text("The journey is the destination.",style: TextStyle(fontSize: 40.0,fontFamily: 'TitilliumWeb', package: 'awesome_package'));
  static final splashText3 = Text("Welcome to Fsحny",style: TextStyle(fontSize: 40.0, fontFamily: 'TitilliumWeb', package: 'awesome_package'));

  @override
  void initState() {
    super.initState();
    _setFirstVisit(false);
  }

  Future<void> _setFirstVisit(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("firstVisit", value);
  }

  Future<void> _nextSplashScreen() async {
    if(_index != 2) {
      setState(() {
        _index++ ;
      });
    }
    else {
      Navigator.of(context).pushReplacement(StartScreenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: myColor[_index],
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.fromLTRB(80.0, 0.0, 90.0, 0.0),
                child: myList[_index],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    type: MaterialType.transparency,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xffF2CE1B),
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(StartScreenRoute());
                      },
                      child: Text("Skip",
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Material(
                    elevation: 5.0,
                    type: MaterialType.transparency,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xffF2CE1B),
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      onPressed: () {
                        _nextSplashScreen();
                      },
                      child: Text("Next",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartScreenRoute extends CupertinoPageRoute {
  StartScreenRoute()
      : super(builder: (BuildContext context) => new StartPage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new StartPage());
  }
}
