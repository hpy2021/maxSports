import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maxsports/Constants/AppColors.dart';
import 'package:maxsports/Constants/AppConstants.dart';
import 'package:maxsports/Constants/AppStrings.dart';
import 'package:maxsports/Views/games_screen.dart';
import 'package:maxsports/Views/home_screen.dart';
import 'package:maxsports/Views/shows_screen.dart';
import 'package:maxsports/Widgets/profileWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationBarView extends StatefulWidget {
  int selectedIndex;

  BottomNavigationBarView({@required this.selectedIndex});

  @override
  _BottomNavigationBarViewState createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  Widget _widget = HomeScreen();
  int _selectedIndex;

  String _appbarText = "Maxx Team";
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _onItemTapped(int index) {
    if (mounted)
      setState(() {
        _selectedIndex = index;
      });
    switch (index) {
      case 0:
        changeAppBarText("Maxx Team");
        changewidget(
          HomeScreen(),
        );
        break;
      case 1:
        changeAppBarText("Live Games");
        changewidget(
          GamesScreen(),
        );
        break;
      case 2:
        changeAppBarText("Live Shows");
        changewidget(
          ShowsScreen(),
        );
        break;
      case 3:
        _drawerKey.currentState.openEndDrawer();
        break;
    }
  }

  changewidget(Widget widget) {
    if (mounted) {
      setState(() {
        _widget = widget;
      });
    }
  }

  changeAppBarText(String text) {
    if (mounted) {
      setState(() {
        _appbarText = text;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _onItemTapped(_selectedIndex);
    _getemailid();
  }

  SharedPreferences prefs;
  String email;

  _getemailid() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString(AppStrings.LOGIN_EMAIL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: AppColors.lightBackGroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$_appbarText",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
              onTap: () {
                AppConstants().logout(context);
              },
              child: Image.asset(
                "assets/images/logout.png",
                height: 19,
              ))
        ],
      ),
      endDrawer: Drawer(
          child: ProfileWidget(
        email: email,
      )),
      body: AnnotatedRegion(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: _widget,
              ),
            ],
          ),
        ),
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      ),
      bottomNavigationBar: _bottomBar2(),
    );
  }

  _bottomBar2() {
    return Container(
      color: AppColors.backGroundColor,
      // height: 100,
      // padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: CustomNavigationBar(
        blurEffect: false,
        scaleFactor: 0.01,
        // iconSize: 20.0,
        borderRadius: Radius.circular(15),
        selectedColor: AppColors.buttonRedColor,
        strokeColor: Colors.transparent,
        unSelectedColor: AppColors.greyColor,
        backgroundColor: Colors.white,
        isFloating: true,

        items: [
          CustomNavigationBarItem(
            icon: Image.asset(
              "assets/images/home.png",
              color: AppColors.greyColor,
              fit: BoxFit.cover,
            ),
            title: Text(
              "Home",
              style: TextStyle(color: AppColors.greyColor, fontSize: 10),
            ),
            selectedTitle: Text(
              "Home",
              style: TextStyle(
                  color: AppColors.buttonRedColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            selectedIcon: Image.asset(
              "assets/images/home.png",
              color: AppColors.buttonRedColor,
              fit: BoxFit.cover,
            ),
          ),
          CustomNavigationBarItem(
            icon: Image.asset(
              "assets/images/gamesIcon.png",
              color: AppColors.greyColor,
              fit: BoxFit.cover,
            ),
            title: Text(
              "Games",
              style: TextStyle(color: AppColors.greyColor, fontSize: 10),
            ),
            selectedTitle: Text(
              "Games",
              style: TextStyle(
                  color: AppColors.buttonRedColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            selectedIcon: Image.asset(
              "assets/images/gamesIcon.png",
              color: AppColors.buttonRedColor,
              fit: BoxFit.cover,
            ),
          ),
          CustomNavigationBarItem(
            icon: Image.asset(
              "assets/images/show.png",
              color: AppColors.greyColor,
              fit: BoxFit.cover,
            ),
            title: Text(
              "Shows",
              style: TextStyle(color: AppColors.greyColor, fontSize: 10),
            ),
            selectedTitle: Text(
              "Shows",
              style: TextStyle(
                  color: AppColors.buttonRedColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            selectedIcon: Image.asset(
              "assets/images/show.png",
              color: AppColors.buttonRedColor,
              fit: BoxFit.cover,
            ),
          ),
          CustomNavigationBarItem(
            icon: Image.asset(
              "assets/images/user.png",
              color: AppColors.greyColor,
              fit: BoxFit.cover,
            ),
            title: Text(
              "Me",
              style: TextStyle(color: AppColors.greyColor, fontSize: 10),
            ),
            selectedTitle: Text(
              "Me",
              style: TextStyle(
                  color: AppColors.buttonRedColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            selectedIcon: Image.asset(
              "assets/images/user.png",
              color: AppColors.buttonRedColor,
              fit: BoxFit.cover,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
