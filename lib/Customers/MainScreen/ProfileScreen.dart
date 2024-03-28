// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Auth/LoginScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/CartScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/CheckingTrack.dart';
import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/HomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/ManageAddressScreen_Page.dart';
import 'package:circularmallbc/Customers/MainScreen/OrderHistoryScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/AddAddressScreen_Page.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/EditProfileScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreenPageWidget extends StatefulWidget {
  const ProfileScreenPageWidget({super.key});

  @override
  State<ProfileScreenPageWidget> createState() =>
      _ProfileScreenPageWidgetState();
}

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("คุณต้องการออกจากระบบหรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm logout
            child: Text("ออกจากระบบ"),
          ),
        ],
      );
    },
  );
}

Future<void> clearSession() async {
  await FirebaseAuth.instance.signOut();
}

class _ProfileScreenPageWidgetState extends State<ProfileScreenPageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('Customers');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
      future:
          _auth.currentUser?.uid != null && _auth.currentUser!.uid.isNotEmpty
              ? users.doc(_auth.currentUser!.uid).get()
              : null,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Still loading
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Handle the error
          return Text("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุณยังไม่ได้เข้าสู่ระบบ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the login screen or handle login logic
                    Navigator.pushNamed(context, LoginPageWidget.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    // Adjust other styling properties as needed
                  ),
                  child: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return GestureDetector(
            child: Scaffold(
              backgroundColor: Color(0xFF57636C),
              appBar: AppBar(
                backgroundColor: Color(0xFF57636C),
                automaticallyImplyLeading: false,
                actions: [],
                centerTitle: false,
                elevation: 0,
              ),
              body: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 140,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image(
                                      image:
                                          NetworkImage('${data['imageUrl']}'),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        '${data['customerName']}'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 41,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        '${data['email']}',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Text(
                        'คอยด์ของฉัน : ${data['coins']} คอยด์',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, -1),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 12),
                                      child: Text(
                                        'ตั้งค่าบัญชี',
                                        style: TextStyle(
                                          color: Color(0xFF101213),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: InkWell(
                                        onTap: () {
                                          // Handle click event, e.g., navigate to another screen
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CartScreenPageWidget()));
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 16, 8),
                                              child: Icon(
                                                Icons.shopping_cart_outlined,
                                                color: Color(0xFF57636C),
                                                size: 24,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 12, 0),
                                                child: Text(
                                                  'ตะกร้าสินค้า',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Color(0xFF101213),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: InkWell(
                                        onTap: () {
                                          // Handle click event, e.g., navigate to another screen
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderHistorysPageWidget()));
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 16, 8),
                                              child: Icon(
                                                Icons.delivery_dining_outlined,
                                                color: Color(0xFF57636C),
                                                size: 24,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 12, 0),
                                                child: Text(
                                                  'คำสั่งซื้อของฉัน',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Color(0xFF101213),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: InkWell(
                                        onTap: () {
                                          // Handle click event, e.g., navigate to another screen
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WishListScreen()));
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 16, 8),
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Color(0xFF57636C),
                                                size: 24,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 12, 0),
                                                child: Text(
                                                  'รายการที่ฉันถูกใจ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Color(0xFF101213),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 8, 16, 8),
                                            child: Icon(
                                              Icons.home_outlined,
                                              color: Color(0xFF57636C),
                                              size: 24,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: Text(
                                                'ที่อยู่ในการจัดส่ง',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF101213),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManageAddressScreenPageWidget()));
                                            },
                                            child: Text(
                                              'จัดการที่อยู่',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF4B39EF),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 8, 16, 8),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Color(0xFF57636C),
                                              size: 24,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 12, 0),
                                              child: Text(
                                                'ตั้งค่าบัญชีผู้ใช้งาน',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF101213),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                             Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfileScreenPageWidget()));
                                            },
                                            child: Text(
                                              'ตั้งค่า',
                                              style: TextStyle(
                                                color: Color(0xFF4B39EF),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: InkWell(
                                        onTap: () async {
                                          // Show confirmation dialog
                                          bool logoutConfirmed =
                                              await showLogoutConfirmationDialog(
                                                  context);

                                          // If user confirms logout
                                          if (logoutConfirmed) {
                                            // Clear session and navigate to the initial screen
                                            // (You need to implement the session clearing logic)
                                            await clearSession();
                                            Navigator.pushNamed(context,
                                                CustomHomeScreen.routeName);
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 16, 8),
                                              child: Icon(
                                                Icons.login_rounded,
                                                color: Color(0xFF57636C),
                                                size: 24,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 12, 0),
                                                child: Text(
                                                  'ออกจากระบบ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Color(0xFF101213),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'ออกจากระบบ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF4B39EF),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
