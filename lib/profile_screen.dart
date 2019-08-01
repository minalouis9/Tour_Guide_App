import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'start_screen.dart';
import 'googleMap_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {

  String _userName = "";
  String _mobileNumber = "";
  String _location = "";
  String _email = "";

  TextEditingController _password = new TextEditingController();

  bool _hidePassword = true;

  void initState() {
    super.initState();
    setState(() {
      _manageLoginData();
      _hidePassword = true;
    });
  }

  Future<void> _setLoginState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loginState", value);
  }

  Future<void> _manageLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("userName");
    final mobileNumber = prefs.getString("mobileNumber");
    final email = prefs.getString("email");
    final country = prefs.getString("country");
    final city = prefs.getString("city");
    final password = prefs.getString("password");

    setState(() {
      _userName = userName.toString();
      _mobileNumber = mobileNumber.toString();
      _email = email.toString();
      _location = country.toString().toUpperCase() + ", " + city.toString().toUpperCase();
      _password.text = password.toString();
    });

  }

  @override
  Widget build(BuildContext context) {

    final iconInvisible = Icon(Icons.visibility_off);
    final iconVisible = Icon(Icons.visibility);

    List<Icon> myIcons = [iconInvisible, iconVisible];

    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _userName,
                    style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            ),
            Divider(height: 1.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _location,
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 30.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0,),
                  Icon(Icons.account_circle,color: Color(0xffF2CE1B),),
                  SizedBox(width: 5.0,),
                  Text(
                    _userName,
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 10.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0,),
                  Icon(Icons.location_on,color: Color(0xffF2CE1B),),
                  SizedBox(width: 5.0,),
                  Text(
                    _location,
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 10.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0,),
                  Icon(Icons.mail,color: Color(0xffF2CE1B),),
                  SizedBox(width: 5.0,),
                  Text(
                    _email,
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 10.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0,),
                  Icon(Icons.phone,color: Color(0xffF2CE1B),),
                  SizedBox(width: 5.0,),
                  Text(
                    _mobileNumber,
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 10.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 5.0,),
                  Icon(Icons.lock,color: Color(0xffF2CE1B),),
                  SizedBox(width: 5.0,),
                  Expanded(
                      child: TextField(
                        controller: _password,
                          readOnly: true,
                          style: TextStyle(color: Color(0xffF2CE1B)),
                          obscureText: _hidePassword,
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
                          )
                      ),
                  )
                ],
              ),
            ),
            Divider(height: 225.0,),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xffF2CE1B),
              child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                onPressed: () {

                },
                child: Text("Disable Account",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Divider(height: 30.0,),
          ],
        ),
      ),
      endDrawer: Drawer(
        elevation: 10.0,
        child: Container(
          color: Colors.yellow,
          child: ListView(
            padding: EdgeInsets.all(2.0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(_userName),
                accountEmail: Text(_mobileNumber),
                decoration: BoxDecoration(color: Color(0xffF2CE1B)),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Home"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.directions_walk),
                title: Text("Track tours"),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Help"),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Logout"),
                onTap: (){
                  _setLoginState(false);
                  _auth.signOut();
                  Navigator.of(context).pushReplacement(new StartScreenRoute());
                },
              )
            ],
          ),
        ),
      ),
    );
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

class StartScreenRoute extends CupertinoPageRoute {
  StartScreenRoute()
      : super(builder: (BuildContext context) => new StartPage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new StartPage());
  }
}