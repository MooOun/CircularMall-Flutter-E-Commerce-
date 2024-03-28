// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/ManageAddressScreen_Page.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/AddAddressScreen_Page.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/OnboardScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/uploadslip.dart';
import 'package:circularmallbc/Customers/MainScreen/wishlist_screen.dart';
import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreenWidget extends StatefulWidget {
  const CheckoutScreenWidget({super.key});

  @override
  State<CheckoutScreenWidget> createState() => _CheckoutScreenWidgetState();
}

class _CheckoutScreenWidgetState extends State<CheckoutScreenWidget> {
  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('Customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('addresses')
      .where('addressStatus', isEqualTo: true)
      .limit(1)
      .snapshots();

  String selectedAddressId = ""; 
  int selectedValue = 1;
  String selectedSize = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('Customers');
  late String orderId;

  @override
  Widget build(BuildContext context) {
    double totalPaid = context.watch<Cart>().totalPrice + 80.0;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("มีบางอย่างผิดพลาด");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("ไม่มีข้อมูลนี้อยู่");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return GestureDetector(
              child: Scaffold(
                backgroundColor: Color(0xFFF1F5F8),
                appBar: AppBar(
                  backgroundColor: Color(0xFFF1F5F8),
                  automaticallyImplyLeading: false,
                  title: Text(
                    'สรุปคำสั่งซื้อ',
                    style: TextStyle(
                      color: Color(0xFF0F1113),
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [],
                  centerTitle: false,
                  elevation: 0,
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Container(
                                width: 365,
                                constraints: BoxConstraints(
                                  maxWidth: 750,
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
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ที่อยู่ของคุณ',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 12),
                                        child: Text(
                                          'ด้านล่างคือรายละเอียดที่อยู่ของคุณ.',
                                          style: TextStyle(
                                            color: Color(0xFF57636C),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 12),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 0,
                                                    color: Color(0xFFE0E3E7),
                                                    offset: Offset(0, 1),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: _addressStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      'Something went wrong'),
                                                );
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        Colors.purple.shade600,
                                                  ),
                                                );
                                              }

                                              
                                              if (snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                  child: Text(
                                                      'ไม่มีข้อมูลที่อยู่'),
                                                );
                                              }

                                              
                                              var addressData =
                                                  snapshot.data!.docs[0].data()
                                                      as Map<String, dynamic>;

                                              if (addressData[
                                                      'addressStatus'] !=
                                                  true) {
                                                return Center(
                                                  child: Text(
                                                      'ไม่มีข้อมูลที่อยู่ที่มี addressStatus เป็น true'),
                                                );
                                              }
                                              // นำข้อมูลไปแสดงใน Widget
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 24),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // แสดงชื่อ - สกุล
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 0, 8),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'ชื่อ - สกุล :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'fullName'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'เบอร์ติดต่อ :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'phone'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'ที่อยู่ :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'address'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'ตำบล :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'tumbon'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'อำเภอ :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'amphoe'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'จังหวัด :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'jangwhat'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'รหัสไปรณีย์ :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'postCode'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'โน๊ต... :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF57636C),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              Text(
                                                                addressData[
                                                                    'noteAddress'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF14181B),
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManageAddressScreenPageWidget()));
                                                  print('Button pressed ...');
                                                },
                                                text: 'เปลี่ยนที่อยู่',
                                                options: FFButtonOptions(
                                                  height: 40,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: Color(0xFF4634EC),
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                  elevation: 3,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddAddressPageWidget()));
                                                  print('Button pressed ...');
                                                },
                                                text: 'เพิ่มที่อยู่ใหม่',
                                                options: FFButtonOptions(
                                                  height: 40,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: Color(0xFF4634EC),
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                  elevation: 3,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 15, 0, 15),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Container(
                                    width: 365,
                                    constraints: BoxConstraints(
                                      maxWidth: 430,
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
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 15, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 16, 16, 24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'สรุปการสั่งซื้อ',
                                                  style: TextStyle(
                                                    color: Color(0xFF14181B),
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 12),
                                                  child: Text(
                                                    'ชำระเงินผ่าน',
                                                    style: TextStyle(
                                                      color: Color(0xFF57636C),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RadioListTile(
                                                        value: 1,
                                                        groupValue:
                                                            selectedValue,
                                                        onChanged:
                                                            (int? value) {
                                                          setState(() {
                                                            selectedValue =
                                                                value!;
                                                          });
                                                        },
                                                        title: Text(
                                                          'ชำระเงินแบบปลายทาง',
                                                        ),
                                                        subtitle: Text(
                                                          '(จ่ายเงินกับพนักงานส่งสินค้า)',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    33,
                                                                    0,
                                                                    197),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                          value: 2,
                                                          groupValue:
                                                              selectedValue,
                                                          onChanged:
                                                              (int? value) {
                                                            setState(() {
                                                              selectedValue =
                                                                  value!;
                                                            });
                                                          },
                                                          title: Text(
                                                            'จ่าย Qrcode Promptpay',
                                                          ),
                                                          subtitle: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        1.0),
                                                                child: Icon(
                                                                  Icons.qr_code,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          33,
                                                                          0,
                                                                          197),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  height: 32,
                                                  thickness: 2,
                                                  color: Color(0xFFE0E3E7),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 12),
                                                  child: Text(
                                                    'ด้านล่างนี้คือรายการสินค้าของคุณ',
                                                    style: TextStyle(
                                                      color: Color(0xFF57636C),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 0,
                                                                    0, 12),
                                                        child: Text(
                                                          'การแบ่งราคา',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF57636C),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'ราคารวมสินค้า',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF57636C),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${context.watch<Cart>().totalPrice.toStringAsFixed(2)} บาท',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'ค่า Vat 7%',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF57636C),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                            Text(
                                                              '40 บาท',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'ค่าขนส่ง',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF57636C),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                            Text(
                                                              '40 บาท',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 8, 0, 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'ราคารวม',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF57636C),
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      30,
                                                                  borderWidth:
                                                                      1,
                                                                  buttonSize:
                                                                      36,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .info_outlined,
                                                                    color: Color(
                                                                        0xFF57636C),
                                                                    size: 18,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'IconButton pressed ...');
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              '${totalPaid.toStringAsFixed(2)} บาท',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 42,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    if (selectedValue == 1) {
                                                      List<dynamic>
                                                          cartItemsCopy =
                                                          List.from(context
                                                              .read<Cart>()
                                                              .getItems);

                                                      if (cartItemsCopy
                                                          .isNotEmpty) {
                                                        CollectionReference
                                                            orderRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Orders');
                                                        CollectionReference
                                                            productsRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Products');

                                                        orderId = Uuid().v4();

                                                      
                                                        QuerySnapshot<
                                                                Map<String,
                                                                    dynamic>>
                                                            addressesSnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Customers')
                                                                .doc(_auth
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'addresses')
                                                                .where(
                                                                    'addressStatus',
                                                                    isEqualTo:
                                                                        true)
                                                                .get();

                                                        // Check if there's a matching address
                                                        if (addressesSnapshot
                                                            .docs.isNotEmpty) {
                                                          Map<String, dynamic>
                                                              selectedAddress =
                                                              addressesSnapshot
                                                                  .docs.first
                                                                  .data();

                                                          double
                                                              totalOrderPrice =
                                                              0.0;

                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              ordersData = [];

                                                          for (var item
                                                              in cartItemsCopy) {
                                                            double
                                                                itemTotalPrice =
                                                                item.quantity *
                                                                    item.price;
                                                            totalOrderPrice +=
                                                                itemTotalPrice;

                                                            await productsRef
                                                                .doc(item
                                                                    .documentId)
                                                                .update({
                                                              'sizes.${item.selectedSize}.quantity':
                                                                  FieldValue
                                                                      .increment(
                                                                          -item
                                                                              .quantity),
                                                              'soldCount': FieldValue
                                                                  .increment(item
                                                                      .quantity), // Add this line
                                                            });

                                                            ordersData.add({
                                                              'productId': item
                                                                  .documentId,
                                                              'orderName':
                                                                  item.name,
                                                              'orderImage': item
                                                                  .imagesUrl
                                                                  .first,
                                                              'orderQuantity':
                                                                  item.quantity,
                                                              'orderPrice':
                                                                  itemTotalPrice,
                                                            });
                                                          }

                                                          // Create a new order document
                                                          await orderRef
                                                              .doc(orderId)
                                                              .set(
                                                            {
                                                              'uid': _auth
                                                                  .currentUser!
                                                                  .uid,
                                                              'customerName': data[
                                                                  'customerName'],
                                                              'email':
                                                                  data['email'],
                                                              'address':
                                                                  selectedAddress[
                                                                      'address'],
                                                              'phone':
                                                                  selectedAddress[
                                                                      'phone'],
                                                              'tumbon':
                                                                  selectedAddress[
                                                                      'tumbon'],
                                                              'amphoe':
                                                                  selectedAddress[
                                                                      'amphoe'],
                                                              'jangwhat':
                                                                  selectedAddress[
                                                                      'jangwhat'],
                                                              'postCode':
                                                                  selectedAddress[
                                                                      'postCode'],
                                                              'noteAddress':
                                                                  selectedAddress[
                                                                      'noteAddress'],
                                                              'orders':
                                                                  ordersData,
                                                              'orderId':
                                                                  orderId,
                                                              'deliveryDate':
                                                                  '',
                                                              'paymentStatus':
                                                                  'COD',
                                                              'orderReview':
                                                                  false,
                                                              'deliveryService':
                                                                  '',
                                                              'totalOrderPrice':
                                                                  totalOrderPrice,
                                                              'trackingNumber':
                                                                  '',
                                                              'orderDate':
                                                                  DateTime
                                                                      .now(),
                                                              'deliverStatus':
                                                                  'notconfirmed',
                                                              'notconfirmed':
                                                                  true,
                                                              'onconfirmed':
                                                                  false,
                                                              'confirmDate': '',
                                                              'prepareTranspot':
                                                                  false,
                                                              'prepareDate': '',
                                                              'transpot': false,
                                                              'transpotDate':
                                                                  '',
                                                              'delivered':
                                                                  false,
                                                              'shippingStatus':
                                                                  '',
                                                              'inshipping':
                                                                  false,
                                                              'inshippingDate':
                                                                  '',
                                                              'Sorting': false,
                                                              'SortingDate': '',
                                                              'shipping': false,
                                                              'shippingDate':
                                                                  '',
                                                            },
                                                          );

                                                          context
                                                              .read<Cart>()
                                                              .clearCart();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OnboardScreenPageWidget()),
                                                          );
                                                          print(
                                                              'Order placed successfully');
                                                        } else {
                                                          // Handle the case when there is no address with addressStatus set to true
                                                          print(
                                                              'No valid address found with addressStatus set to true.');
                                                        }
                                                      }
                                                    } else if (selectedValue ==
                                                        2) {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          double
                                                              bottomSheetHeight =
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7;

                                                          return SizedBox(
                                                            height: bottomSheetHeight >
                                                                    200
                                                                ? bottomSheetHeight
                                                                : 200,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'แสกนชำระเงินผ่าน QR CODE',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Container(
                                                                  height: bottomSheetHeight -
                                                                      150, // Adjust as needed
                                                                  width: bottomSheetHeight -
                                                                      150, // Adjust as needed
                                                                  child:
                                                                      QrImageView(
                                                                    data: '',
                                                                    version:
                                                                        QrVersions
                                                                            .auto,
                                                                    size:
                                                                        bottomSheetHeight -
                                                                            20,
                                                                    gapless:
                                                                        false,
                                                                    embeddedImage:
                                                                        AssetImage(
                                                                            'assets/images/app_logo/qr.png'),
                                                                    embeddedImageStyle:
                                                                        QrEmbeddedImageStyle(
                                                                      size: Size(
                                                                          160,
                                                                          160),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                CyanButton(
                                                                  buttonTitle:
                                                                      'อัพโหลดสลิป',
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context); // Close the bottom sheet
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                UploadSlipPage(
                                                                          data:
                                                                              data,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  text:
                                                      'ดำเนินการสั่งสินค้าต่อ',
                                                  options: FFButtonOptions(
                                                    width: double.infinity,
                                                    height: 50,
                                                    padding: EdgeInsets.all(0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 0, 0),
                                                    color: Color(0xFF4B39EF),
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    elevation: 2,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    hoverColor:
                                                        Color(0x4C4B39EF),
                                                    hoverBorderSide: BorderSide(
                                                      color: Color(0xFF4B39EF),
                                                      width: 1,
                                                    ),
                                                    hoverTextColor:
                                                        Color(0xFF4B39EF),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
