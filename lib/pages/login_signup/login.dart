import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/FRS/db/database.dart';
import 'package:tritek_lms/FRS/models/user.model.dart';
import 'package:tritek_lms/FRS/widgets/auth-action-button.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/entity/courses.dart';
import 'package:tritek_lms/data/entity/subscription.plans.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/google.login.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/course/course.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/capture.dart';
import 'package:tritek_lms/pages/login_signup/captureSignIn.dart';
import 'package:tritek_lms/pages/login_signup/dialog.dart';
import 'package:tritek_lms/pages/login_signup/forgot_password.dart';
import 'package:tritek_lms/pages/login_signup/signup.dart';
import 'package:tritek_lms/pages/payment/select_plan.dart';

class Login extends StatefulWidget {
  final Course _course;
  final SubscriptionPlans _subscriptionPlans;

  Login(this._course, this._subscriptionPlans);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  DateTime currentBackPressTime;

  final GoogleLogin _googleLogin = GoogleLogin();
  final _formKey = GlobalKey<FormState>();
  final UserRepository _repository = UserRepository();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final userBloc = UserBloc();
  CameraDescription cameraDescription;
 
  String _username;
  var _password;

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  var capture = DataBaseService().loadDB();

  @override
  void initState() {
    super.initState();
    userBloc.userStatus.listen((value) {
      if (!mounted) {
        return;
      }
      if (value == true) {
        // userBloc.dispose();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: Home()));
        return;
      }
    });

    userBloc.getUser();
  }



  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  _showDialog(BuildContext context) {
      VoidCallback continueCallBack = () => {
            Navigator.of(context).pop(),
            // code on continue comes here
          };
      BlurryDialog alert = BlurryDialog("Face Recognition System",
          "Would you like to use this update?", );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/appbar_bg.png'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.67),
                    Colors.black.withOpacity(0.79),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 70.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'MyTritek',
                            style: TextStyle(
                              color: themeGold,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Login to your account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          focusNode: _usernameFocusNode,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(value, 3,
                                'Username is required, min length is 4');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintText: 'Username or email',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (username) => _username = username,
                          onFieldSubmitted: (_) {
                            fieldFocusChange(context, _usernameFocusNode,
                                _passwordFocusNode);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          focusNode: _passwordFocusNode,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.required(value, 5,
                                'Password is required, min length is 6');
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 20.0, top: 13.0, bottom: 12.0),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              // fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: _viewPassword,
                            ),
                          ),
                          onSaved: (password) => _password = password,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: SizedBox(
                        height: 50.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.5, 0.9],
                              colors: [
                                Colors.yellow[300].withOpacity(0.6),
                                Colors.yellow[500].withOpacity(0.8),
                                Colors.yellow[600].withOpacity(1.0),
                              ],
                            ),
                          ),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                login(context);
                              }
                            },
                            color: Colors.transparent,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SignUp()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ForgotPassword()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontFamily: 'Signika Negative',
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        onTap: () {
                          _googleLogin.handleSignIn().then((acc) => {
                                if (acc != null)
                                  {
                                    _loginGoogle(acc),
                                  }
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/google.png',
                                height: 25.0,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Login with Google',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
  }

  Future<void> login(BuildContext context) async {
    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Login you in...'); //invoking login
      UserResponse _response = await _repository.login(_username, _password);
      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        _successRoute(_response);
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'Invalid credentials', ''); //invoking log
    }
  }

  _successRoute(UserResponse response) {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    if (widget._course != null && response.results.status == 'active') {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: _capturedData()));
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: _capturedData()));
    }
  }

  _loginGoogle(GoogleSignInAccount acc) async {
    LoadingDialogs.showLoadingDialog(context, _keyLoader, 'Login you in...');
    print(acc);
    try {
      final resp = await _repository.googleLogin(acc);

      print(resp.results?.email);
      if (resp.results != null) {
        _successRoute(resp);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred, Please try again', ''); //invoking log
    }
  }

  _capturedData() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    if (capture != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: CaptureSignIn(
                cameraDescription: cameraDescription,
              )));
    } else {
      // ignore: unnecessary_statements
      _showDialog;
    }
    
  }
}
