import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tritek_lms/custom/bubble_bottom_bar.dart';
import 'package:tritek_lms/pages/home/home_main.dart';
import 'package:tritek_lms/pages/my_course.dart';
import 'package:tritek_lms/pages/search.dart';
import 'package:tritek_lms/pages/settings/settings.dart';
import 'package:tritek_lms/pages/wishlist.dart';

import '../../appTheme/appTheme.dart';
import '../my_course.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex;
  DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        hasNotch: false,
        opacity: 0.2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: themeBlue,
            color: themeGold,
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.home,
              color: themeGold,
            ),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: themeBlue,
            color: themeGold,
            icon: Icon(
              Icons.play_circle_outline_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.play_circle_outline_outlined,
              color: themeGold,
            ),
            title: Text(
              'My Courses',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BubbleBottomBarItem(
              backgroundColor: themeBlue,
              color: themeGold,
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.search,
                color: themeGold,
              ),
              title: Text(
                'Search',
                style: TextStyle(fontSize: 10.0),
              )),
          BubbleBottomBarItem(
            backgroundColor: themeBlue,
            color: themeGold,
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.favorite_border,
              color: themeGold,
            ),
            title: Text(
              'Wishlist',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          BubbleBottomBarItem(
              backgroundColor: themeBlue,
              color: themeGold,
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.settings,
                color: themeGold,
              ),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 10.0),
              ))
        ],
      ),
      body: WillPopScope(
            child: (currentIndex == 0)
                ? HomeMain()
                : (currentIndex == 1)
                    ? MyCourse()
                    : (currentIndex == 2)
                    ? Search()
                    : (currentIndex == 3)
                        ? Wishlist()
                        : Settings(),
            onWillPop: onWillPop,
          ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: Theme.of(context).appBarTheme.color,
      );
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }
  
}
