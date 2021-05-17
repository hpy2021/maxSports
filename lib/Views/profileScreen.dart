import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
key: _drawerKey ,

   body: _scffoldKey());
  }
  _scffoldKey(){
    _drawerKey.currentState.openDrawer();

    return Scaffold(
      drawer: Drawer(
        key: _drawerKey,
      ),
    );
  }
}
