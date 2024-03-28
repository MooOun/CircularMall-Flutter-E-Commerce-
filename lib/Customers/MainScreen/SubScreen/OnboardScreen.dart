// ignore_for_file: prefer_const_constructors

import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardScreenPageWidget extends StatefulWidget {
  const OnboardScreenPageWidget({Key? key}) : super(key: key);

  @override
  State<OnboardScreenPageWidget> createState() =>
      _OnboardScreenPageWidgetState();
}

class _OnboardScreenPageWidgetState extends State<OnboardScreenPageWidget> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String customerName = _user?.displayName ?? '';
    String email = _user?.email ?? '';

    // ในกรณีที่ไม่ได้กำหนด displayName ใน Firebase Auth
    // คุณอาจจะใช้ email แทน
    if (customerName.isEmpty) {
      customerName = email;
    }

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 24, 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0x4C39D2C0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0x4C39D2C0),
                        width: 4,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Color(0xFF39D2C0),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0x4C39D2C0),
                            width: 4,
                          ),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                  child: Text(
                    'คำสั่งซื้อของคุณสำเร็จเเล้ว 🎉',
                    style: TextStyle(
                          color: Color(0xFF15161E),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  'ยินดีด้วย คุณได้สั่งซื้อสินค้านเรียบร้อยแล้ว ..',
                  style: TextStyle(
                        color: Color(0xFF606A85),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Divider(
                  height: 16,
                  thickness: 2,
                  color: Color(0xFFE5E7EB),
                ),
                Text(
                  customerName,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                        color: Color(0xFF15161E),
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                
                Spacer(),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.pushNamed(context, CustomHomeScreen.routeName);
                      print('Button pressed ...');
                    },
                    text: 'กลับหน้าหลัก',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 44,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFF6F61EF),
                      textStyle:
                          TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 8)),
            ),
          ),
        ),
      ),
    );
  }
}
