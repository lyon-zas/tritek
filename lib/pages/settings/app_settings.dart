import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/notificationsBloc.dart';
import 'package:tritek_lms/blocs/settings.bloc.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  // bool cellularData;
  bool cellularData = true;
  bool notifications = false;
  String notificationTime = '..:..';
  bool standard = true;
  bool high = false;
  bool delete = true;

  @override
  void initState() {
    super.initState();
    settingsBloc.getSettings();

    settingsBloc.notifications.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        notifications = value;
      });
    });

    settingsBloc.cellularData.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cellularData = value;
      });
    });

    settingsBloc.notificationTime.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        notificationTime = value;
      });
    });

    settingsBloc.videoQuality.listen((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        high = value == 2;
        standard = value == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Container getDivider(Color color) {
      return Container(
        height: 1.0,
        width: width,
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        color: color,
      );
    }

    nestedAppBar() {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              backgroundColor: themeBlue,
              pinned: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: themeGold,),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              flexibleSpace: LayoutBuilder(builder:
                  (BuildContext context, BoxConstraints constraints) {
                // top = constraints.biggest.height;
                return FlexibleSpaceBar(
                    centerTitle: false,
                    title: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      //opacity: top == 80.0 ? 1.0 : 0.0,
                      opacity: 1.0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: themeBlue,
                        ),
                        child: Text(
                          'App Settings',
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: themeGold,
                          ),
                        ),
                      ),
                    ),
                    background: Container(
                      padding: EdgeInsets.all(20.0),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          color: themeBlue
                      ),
                    ));
              }),
              automaticallyImplyLeading: false,
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            SizedBox(height: 15.0),
            Container(
              margin: EdgeInsets.only(right: 20.0, left: 20.0),
              width: width - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cellular Data',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cellular Data for Videos',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      // if (cellularData)
                      //   CustomSwitch(
                      //     activeColor: textColor,
                      //     value: false,
                      //     onChanged: (value) {
                      //       settingsBloc.setCellularData(value);
                      //     },
                      //   ),
                      // if (!cellularData)
                      Switch(
                        activeColor: textColor,
                        value: cellularData,
                        onChanged: (value) {
                          settingsBloc.setCellularData(value);
                        },
                      ),
                    ],
                  ),
                  getDivider(Colors.grey[300]),
                  SizedBox(height: 10.0),
                  Text(
                    'Video Quality',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 15.0),
                  InkWell(
                    onTap: () {
                      settingsBloc.setVideoQuality(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Standard (recommended)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Load faster and uses less data',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          (standard) ? Icons.check : null,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),
                  InkWell(
                    onTap: () {
                      settingsBloc.setVideoQuality(2);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'High Definition',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Use more data',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          (high) ? Icons.check : null,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),
                  SizedBox(height: 10.0),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: themeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Signika Negative',
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Turn on Daily Notifications',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Signika Negative',
                        ),
                      ),
                      Switch(
                        activeColor: textColor,
                        value: notifications,
                        onChanged: (value) {
                          settingsBloc.setNotifications(value);
                          if (value) {
                            turnOnNotifications();
                          } else {
                            notificationsBloc.cancelAllNotifications();
                          }
                        },
                      ),
                    ],
                  ),
                  getDivider(Colors.grey[300]),
                  InkWell(
                    onTap: () {
                      if (!notifications) {
                        return;
                      }
                      setTime();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Notification Time',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              notificationTime,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[400],
                                fontFamily: 'Signika Negative',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  getDivider(Colors.grey[300]),

                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: nestedAppBar(),
    );
  }

  void setTime() async {
    Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    selectedTime.then((value) =>
    {
          settingsBloc.setNotificationTime(
              twoDigits(value.hour) + ':' + twoDigits(value.minute)),
          notificationsBloc.scheduleDailyTenAMNotification(
              'Time to continue your lessons!',
              'Continue your lessons on MyTritek App',
              value.hour,
              value.minute),
          print(value.toString())
        });
  }

  void turnOnNotifications() async {
    if (Platform.isIOS) {
      final bool result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (result) {
        notificationsBloc.displayNotification(
            'MyTritek Notifications', 'Notifications turned On', '');
        settingsBloc.setNotifications(true);
      }
    } else {
      notificationsBloc.displayNotification(
          'MyTritek Notifications', 'Notifications turned On', '');
      settingsBloc.setNotifications(true);
    }
  }
}
