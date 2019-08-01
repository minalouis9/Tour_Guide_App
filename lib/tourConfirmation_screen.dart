import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<ConfirmationPage> {

  String _totalTime = "";
  String _totalCost = "";

  void initState() {
    super.initState();
    _manageLoginData();
  }

  void _manageLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final totalTime= prefs.getDouble("totalTime");

    double totalTimeCost = totalTime * 60;
    double totalCost = totalTimeCost + 10.0;

    setState(() {
      _totalTime = totalTime.toInt().toString();
      _totalCost = totalCost.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Duration : " + _totalTime + " hours",
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 20.0,),
            Container(
              margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Color(0xffF2CE1B)),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total Cost : " + _totalCost + " L.E",
                    style: TextStyle(color: Color(0xffF2CE1B), fontSize: 17.0),
                  ),
                ],
              ),
            ),
            Divider(height: 250,),
            Container(
              margin: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width - 50.0,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xffF2CE1B),
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  onPressed: () {

                  },
                  child: Text("Confirm",
                      textAlign: TextAlign.center,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}