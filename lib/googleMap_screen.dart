import 'dart:async';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'start_screen.dart';
import 'tourConfirmation_screen.dart';
import 'profile_screen.dart';

String apiKEY;

final GoogleSignIn _googleSignIn = GoogleSignIn();

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = "";
  String _mobileNumber = "";

  bool _oneMarker = false;
  bool _dateSelected = false;
  bool _startTimeSelected = false;
  bool _endTimeSelected = false;
  String _startTime = "Start Time";
  String _endTime = "End Time";
  String _startTimeHours = DateTime.now().hour.toString();
  String _endTimeHours = DateTime.now().hour.toString();
  String _startTimeMinutes = DateTime.now().minute.toString();
  String _endTimeMinutes = DateTime.now().minute.toString();
  String _date = "Date";

  var position;
  bool mapLoaded = false;
  bool _loactionEnabled = false;
  LatLng searchPosition;
  Set<Marker> _markers = {};
  List<LatLng> latlng = List();

  void initState() {
    super.initState();
    Geolocator().isLocationServiceEnabled().then((value){
      setState(() {
        _loactionEnabled = value;
      });
    });
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((currentLocation) {
      setState(() {
        position = currentLocation;
        _setLoginState(true);
        _manageLoginData();
        mapLoaded = true;
        _loactionEnabled = true;
      });
    });
  }

  Future<void> _manageLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("userName");
    final mobileNumber = prefs.getString("mobileNumber");
    _userName = userName.toString();
    _mobileNumber = mobileNumber.toString();
  }

  Future<void> _isLocationEnabled() async {
    await Geolocator().isLocationServiceEnabled().then((value){
      setState(() {
        _loactionEnabled = value;
      });
    });
  }

  Future<void> _setLoginState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loginState", value);
  }

  Future<void> _removeMarker() async {
    setState(() {
      if(_oneMarker) {
        _markers.clear();
        _oneMarker = false;
      }
    });
  }

  Future<void> _handleTap(LatLng point) async {
    setState(() {
      if(_markers.length != 1) {
        _markers.add(
            Marker(
              markerId: MarkerId(point.toString()),
              position: point,
              draggable: true,
              icon:
              BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            )
        );
      }
      if(_markers.length == 1){
        setState(() {
          _oneMarker = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          overflow: Overflow.clip,
          children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: mapLoaded
                ? GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14.4746),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: _handleTap,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              indoorViewEnabled: true,
            )
                : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  //padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 0.0),
                      child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: mapLoaded
                            ? SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SearchMapPlaceWidget(
                                    apiKey: "AIzaSyD8tCdvOoxcR9AeocdHQxPGVwu8KCk6A7o",
                                    location: LatLng(position.latitude, position.longitude),
                                    radius: 30000,
                                    onSelected: (place) async {
                                      final geolocation = await place.geolocation;
                                      final GoogleMapController controller = await _controller.future;
                                      controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                                      controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                                    },
                                  ),
                                  Divider(height: 8.0,),
                                  _oneMarker
                                      ? Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(color: Color(0xffF2CE1B)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(30.0),
                                              color: Color(0xffF2CE1B),
                                              child: MaterialButton(
                                                //minWidth: MediaQuery.of(context).size.width - 240.0,
                                                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                                onPressed: () {
                                                  DatePicker.showTimePicker(context,
                                                      showTitleActions: true,
                                                      onConfirm: (date) {
                                                        setState(() {
                                                          _startTimeHours = date.hour.toString();
                                                          _startTimeMinutes = date.minute.toString();
                                                          _startTime = _startTimeHours + ":" + _startTimeMinutes;
                                                          _startTimeSelected = true;
                                                        });
                                                      }, locale: LocaleType.en);
                                                },
                                                child: Text(_startTime,
                                                  style: TextStyle(fontSize: 17.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(30.0),
                                              color: Color(0xffF2CE1B),
                                              child: MaterialButton(
                                                //minWidth: MediaQuery.of(context).size.width - 240.0,
                                                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                                onPressed: () {
                                                  DatePicker.showTimePicker(context,
                                                      showTitleActions: true,
                                                      onConfirm: (date) {
                                                        setState(() {
                                                          _endTimeHours = date.hour.toString();
                                                          _endTimeMinutes = date.minute.toString();
                                                          _endTime = _endTimeHours + ":" + _endTimeMinutes;
                                                          _endTimeSelected = true;
                                                        });
                                                      }, locale: LocaleType.en);
                                                },
                                                child: Text(_endTime,
                                                  style: TextStyle(fontSize: 17.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(30.0),
                                              color: Color(0xffF2CE1B),
                                              child: MaterialButton(
                                                //minWidth: MediaQuery.of(context).size.width - 52.0,
                                                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                                                onPressed: () {
                                                  DatePicker.showDatePicker(context,
                                                      showTitleActions: true,
                                                      onConfirm: (date) {
                                                        setState(() {
                                                          _date = date.day.toString() + " / " + date.month.toString() + " / " + date.year.toString();
                                                          _dateSelected = true;
                                                        });
                                                      }, locale: LocaleType.en);
                                                },
                                                child: Text(_date,
                                                  style: TextStyle(fontSize: 17.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            )
                            : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                )
              )
          ),
            Align(
              alignment: Alignment.center,
              child: _loactionEnabled ? 
              SizedBox()
                  :
              AlertDialog(
                backgroundColor: Colors.yellow,
                content: Text("Please enable location service ..."),
                actions: <Widget>[
                  Builder(builder: (BuildContext context){
                    return MaterialButton(
                      child: Text("Loaction Enabled"),
                      onPressed: (){
                        _isLocationEnabled();
                        if(!_loactionEnabled){
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Loaction service not enabled yet !!!"), duration: Duration(seconds: 3),)
                          );
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(60.0, 0.0, 100.0, 15.0),
                child: Builder(builder: (BuildContext context){
                  return Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xffF2CE1B),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        onPressed: () {
                          if(_oneMarker){
                            if(!_startTimeSelected || !_endTimeSelected){
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Please select the time of the tour !!!"), duration: Duration(seconds: 3),)
                              );
                            }
                            else if(!_dateSelected){
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Please select the date of the tour !!!"), duration: Duration(seconds: 3),)
                              );
                            }
                            else{
                              _calculateTotalTime();
                              Navigator.of(context).push(ConfirmationScreenRoute());
                            }
                          }
                          else {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("Please select the place of the tour !!!"), duration: Duration(seconds: 3),)
                            );
                          }
                        },
                        child: Text(
                          "Order",
                          textAlign: TextAlign.center,
                        ),
                      )
                  );
                }
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 65.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _oneMarker
                        ?
                    FloatingActionButton(
                      heroTag: "removeMarker",
                      elevation: 5.0,
                      onPressed: () {
                        _removeMarker();
                      },
                      backgroundColor: Color(0xffF2CE1B),
                      child: Icon(
                        Icons.location_off,
                        color: Colors.black,
                      ),
                    )
                        :
                    Container(),
                    Divider(height: 5.0,),
                    FloatingActionButton(
                      heroTag: "getCurrentLocation",
                      elevation: 5.0,
                      onPressed: () {
                        _goToCurrentPosition();
                      },
                      backgroundColor: Color(0xffF2CE1B),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      drawer: Drawer(
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
                title: Text("Profile"),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(new ProfileScreenRoute());
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
                  _googleSignIn.signOut();
                  Navigator.of(context).pushReplacement(new StartScreenRoute());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    _isLocationEnabled();
    Position position1 = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(position1.latitude, position1.longitude)));
  }

  Future<void> _calculateTotalTime() async {
    double totalTime = (double.parse(_endTimeHours) - double.parse(_startTimeHours)) + (double.parse(_endTimeMinutes) - double.parse(_startTimeMinutes)) / 60.0;
    final prefs = await SharedPreferences.getInstance();
    //totalTime.toStringAsFixed(1);
    prefs.setDouble("totalTime", totalTime);
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

class ConfirmationScreenRoute extends CupertinoPageRoute {
  ConfirmationScreenRoute()
      : super(builder: (BuildContext context) => new ConfirmationPage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new ConfirmationPage());
  }
}

class ProfileScreenRoute extends CupertinoPageRoute {
  ProfileScreenRoute()
      : super(builder: (BuildContext context) => new ProfilePage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new ProfilePage());
  }
}