// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Auth/RegisterScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/Auth_Models/login_page_model.dart';
export '../Model/Auth_Models/login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  static const String routeName = 'LoginScreen';

  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
              stops: [0, 1],
              begin: AlignmentDirectional(0.87, -1),
              end: AlignmentDirectional(-0.87, 1),
            ),
          ),
          alignment: AlignmentDirectional(0, -1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                  child: Container(
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: AlignmentDirectional(0, 0),
                    child: Text(
                      'CircularMall',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 570,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'ยินดีต้อนรับกลับ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF101213),
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                              child: Text(
                                'กรอกข้อมูลด้านล่างเพื่อเข้าใช้งานบัญชีของคุณ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.emailAddressController,
                                  focusNode: _model.emailAddressFocusNode,
                                  autofocus: true,
                                  autofillHints: [AutofillHints.email],
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'อีเมล',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF57636C),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFF1F4F8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF4B39EF),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF1F4F8),
                                  ),
                                  style: TextStyle(
                                    color: Color(0xFF101213),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _model
                                      .emailAddressControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.passwordController,
                                  focusNode: _model.passwordFocusNode,
                                  autofocus: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility,
                                  decoration: InputDecoration(
                                    labelText: 'รหัสผ่าน',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF57636C),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFF1F4F8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF4B39EF),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF1F4F8),
                                    suffixIcon: InkWell(
                                      onTap: () => setState(
                                        () => _model.passwordVisibility =
                                            !_model.passwordVisibility,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Color(0xFF57636C),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Color(0xFF101213),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  validator: _model.passwordControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                      email: _model.emailAddressController.text,
                                      password: _model.passwordController.text,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomHomeScreen()),
                                    );
                                    print(
                                        'Login Successful: ${userCredential.user?.email}');
                                  } catch (e) {
                                    print('Login Failed: $e');
                                    // Handle login failure (show error message, etc.)
                                  }
                                },
                                text: 'เข้าสู่ระบบ',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 44,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF4B39EF),
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  elevation: 3,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                              child: Text(
                                'หรือ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: FFButtonWidget(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPageWidget()),
                                    );
                                  print('Button pressed ...');
                                },
                                text: 'สมัครสมาชิก',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 44,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Colors.white,
                                  textStyle: TextStyle(
                                    color: Color(0xFF101213),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: Color(0xFFF1F4F8),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  hoverColor: Color(0xFFF1F4F8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
