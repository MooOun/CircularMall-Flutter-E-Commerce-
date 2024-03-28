// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:circularmallbc/Customers/MainScreen/CheckoutScreem.dart';
import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';

class CartScreenPageWidget extends StatefulWidget {
  const CartScreenPageWidget({Key? key}) : super(key: key);

  @override
  _CartScreenPageWidgetState createState() => _CartScreenPageWidgetState();
}

class _CartScreenPageWidgetState extends State<CartScreenPageWidget> {
  bool isDiscountApplied = false;
  double discountAmount = 50;

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('Customers')
        .doc(user?.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color(0xFFF1F5F8),
        appBar: AppBar(
          backgroundColor: Color(0xFFF1F5F8),
          automaticallyImplyLeading: false,
          title: Text(
            'ตะกร้าสินค้า',
            style: TextStyle(
              fontFamily: 'Kanit-Bold',
              color: Color(0xFF0F1113),
              fontSize: 40,
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'ด้านล่างนี้คือรายการสินค้าในรถเข็นของคุณ.',
                        style: TextStyle(
                          color: Color(0xFF57636C),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Consumer<Cart>(
                        builder: (context, cart, child) {
                          return ListView(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: cart.count! > 0
                                ? cart.getItems.map((product) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 8, 16, 0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x320E151B),
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 8, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  product.imagesUrl.first
                                                      .toString(),
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 8),
                                                        child: Text(
                                                          product.name,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ราคา / หน่วย ${product.price.toStringAsFixed(2)} บาท',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        8,
                                                                        10,
                                                                        0),
                                                            child: Text(
                                                              'จำนวน : ${product.quantity} ชิ้น',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        8,
                                                                        10,
                                                                        0),
                                                            child: Text(
                                                              'ไซส์ : ${product.selectedSize}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  product.quantity == 1
                                                      ? IconButton(
                                                          onPressed: () {
                                                            cart?.removeItem(
                                                                product);
                                                          },
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            cart.decreament(
                                                                product);
                                                          },
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${product.quantity}',
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      cart.increament(product);
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ขณะนี้ตระกร้าของคุณ',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          Text(
                                            'ไม่มีสินค้า !',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          // Add your button or UI widget here for navigation
                                        ],
                                      ),
                                    ),
                                  ],
                          );
                        },
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loading indicator while fetching data
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          double userCoins =
                              (snapshot.data?['coins'] ?? 0).toDouble();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 16, 24, 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'การแบ่งราคา.',
                                        style: TextStyle(
                                          color: Color(0xFF0F1113),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'ส่วนลด',
                                            style: TextStyle(
                                              color: Color(0xFF57636C),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            borderWidth: 1,
                                            buttonSize: 36,
                                            icon: Icon(
                                              isDiscountApplied
                                                  ? Icons.toggle_on_outlined
                                                  : Icons.toggle_off_outlined,
                                              color: Color(0xFF57636C),
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                // Toggle the discount status
                                                isDiscountApplied =
                                                    !isDiscountApplied;

                                                // Apply the discount based on the user's coin
                                                if (isDiscountApplied) {
                                                  double userCoins = (snapshot
                                                              .data?['coins'] ??
                                                          0)
                                                      .toDouble();
                                                  discountAmount = userCoins;
                                                } else {
                                                  // Reset the discount amount when the toggle is off
                                                  discountAmount = 0;
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: Text(
                                        '${userCoins.toStringAsFixed(0)} เหรียญ',
                                        style: TextStyle(
                                          color: Color(0xFF0F1113),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 8, 24, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ราคาสินค้า',
                                        style: TextStyle(
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        Provider.of<Cart>(context, listen: true)
                                                .totalPrice
                                                .toStringAsFixed(0) +
                                            ' บาท',
                                        style: TextStyle(
                                          color: Color(0xFF0F1113),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 4, 24, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'ราคารวม',
                                            style: TextStyle(
                                              color: Color(0xFF57636C),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            borderWidth: 1,
                                            buttonSize: 36,
                                            icon: Icon(
                                              Icons.info_outlined,
                                              color: Color(0xFF57636C),
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              // Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               CheckoutScreenWidget()));
                                              print('IconButton pressed ...');
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (isDiscountApplied
                                                ? (Provider.of<Cart>(context,
                                                                listen: true)
                                                            .totalPrice -
                                                        discountAmount)
                                                    .toStringAsFixed(0)
                                                : Provider.of<Cart>(context,
                                                        listen: true)
                                                    .totalPrice
                                                    .toStringAsFixed(0)) +
                                            ' บาท',
                                        style: TextStyle(
                                          color: Color(0xFF0F1113),
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Discount Section
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFF827AE1),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x320E151B),
                    offset: Offset(0, -2),
                  )
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              alignment: AlignmentDirectional(0, 0),
              child: TextButton(
                onPressed:
                    Provider.of<Cart>(context, listen: true).totalPrice == 0.0
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreenWidget(),
                              ),
                            );
                          },
                child: Text(
                  'เช็คเอ้าท์ ( ${Provider.of<Cart>(context, listen: true).totalPrice.toStringAsFixed(0)} บาท )',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
