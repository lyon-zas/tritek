import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/custom/form.validators.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/user.dart';
import 'package:tritek_lms/pages/common/dialog.dart';
import 'package:tritek_lms/pages/login_signup/reset_password.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserRepository _repository = UserRepository();

  String _email;

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
              body: ListView(
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
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 70.0),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25, bottom: 20),
                    child: Text(
                      'Enter your registered email to request an OTP to reset your account password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return Validator.email(value);
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onSaved: (value) => _email = value,
                        ),
                      ),
                    ),

                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(20.0),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 10.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[200].withOpacity(0.3),
                  //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //     ),
                  //     child: InternationalPhoneNumberInput(
                  //       textStyle: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //       initialValue: PhoneNumber(
                  //           phoneNumber: '', isoCode: '+1', dialCode: '+1'),
                  //       // autoValidate: false,
                  //       selectorTextStyle: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16.0,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //       selectorConfig: SelectorConfig(
                  //         selectorType: PhoneInputSelectorType.DIALOG,
                  //       ),
                  //       inputBorder: InputBorder.none,
                  //       inputDecoration: InputDecoration(
                  //         // contentPadding: EdgeInsets.only(left: 20.0),
                  //         hintText: 'Phone Number',
                  //         hintStyle: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16.0,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //         border: InputBorder.none,
                  //       ),
                  //       onInputChanged: (PhoneNumber value) {},
                  //     ),
                  //   ),
                  // ),
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
                              resetPassword(context);
                            }
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.rightToLeft,
                            //         child: OTPScreen(null, , 2)));
                          },
                          color: Colors.transparent,
                          child: Text(
                            'Request OTP',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    try {
      LoadingDialogs.showLoadingDialog(
          context, _keyLoader, 'Processing your details'); //invoking login
      RegisterResponse _response = await _repository.resetPassword(_email);
      if (_response.error.length > 0) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop();

        ServerValidationDialog.errorDialog(
            context, _response.error, _response.eTitle); //invoking log
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ResetPasswordScreen(_response.otp, _email, 2)));
      }
    } catch (error) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ServerValidationDialog.errorDialog(
          context, 'An Error Occurred, Please try again', ''); //invoking log
      print(error);
    }
  }
}
