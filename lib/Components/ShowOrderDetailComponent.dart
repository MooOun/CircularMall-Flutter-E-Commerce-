// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ShowOrderDetailComponentWidget extends StatefulWidget {
  const ShowOrderDetailComponentWidget({
    super.key,
    required this.orderData,
  });
  final QueryDocumentSnapshot<Object?> orderData;

  @override
  State<ShowOrderDetailComponentWidget> createState() =>
      _ShowOrderDetailComponentWidgetState();
}

class _ShowOrderDetailComponentWidgetState
    extends State<ShowOrderDetailComponentWidget> {
  late double rate;
  late String comment;
  late String selectedProductId = '';
  late bool hasReviewed = false;

  @override
  Widget build(BuildContext context) {
    print('Delivery Status : ${widget.orderData['deliverStatus']}');
    return SingleChildScrollView(
      child: Container(
        width: 300,
        constraints: BoxConstraints(
          maxWidth: 570,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      text: () {
                        if (widget.orderData['deliverStatus'] ==
                            'notconfirmed') {
                          return 'ยังไม่ได้ยืนยันคำสั่งซื้อ';
                        } else if (widget.orderData['deliverStatus'] ==
                            'onconfirmed') {
                          return 'ยืนยันคำสั่งซื้อแล้ว';
                        } else if (widget.orderData['deliverStatus'] ==
                            'preparetransport') {
                          return 'เตรียมสินค้าเพื่อมอบให้ขนส่ง';
                        } else if (widget.orderData['deliverStatus'] ==
                            'transport') {
                          return 'มอบสินค้าให้กับขนส่งแล้ว';
                        } else if (widget.orderData['deliverStatus'] ==
                            'Delivered') {
                          return 'จัดส่งเรียบร้อยเเล้ว';
                        } else {
                          return 'ข้อความที่คุณต้องการในกรณีอื่น ๆ';
                        }
                      }(),
                      options: FFButtonOptions(
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFF6F61EF),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ราคารวมสินค้า',
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF606A85),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ราคา : ${widget.orderData['totalOrderPrice'].toString()} บาท',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF15161E),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ].divide(SizedBox(height: 4)),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0x4D9489F5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF6F61EF),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional(0, 0),
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            shape: BoxShape.circle,
                          ),
                          alignment: AlignmentDirectional(0, 0),
                          child: Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            color: Color(0xFF606A85),
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0x4D9489F5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF6F61EF),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1505033575518-a36ea2ef75ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZSUyMHVzZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=900&q=60',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 16)),
                ),
              ),
              Text(
                'ผู้รับสินค้า',
                style: TextStyle(
                  fontFamily: 'Kanit-Bold',
                  color: Color(0xFF606A85),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.orderData['customerName'],
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'Kanit-Bold',
                  color: Color(0xFF15161E),
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Text(
                  widget.orderData['email'],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Kanit-Bold',
                    color: Color(0xFF6F61EF),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ข้อมูลรายการคำสั่งซื้อ',
                            style: TextStyle(
                              fontFamily: 'Kanit-Bold',
                              color: Color(0xFF606A85),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width:
                            8), // Add some space between the text and the button
                    Visibility(
                      visible: widget.orderData['deliverStatus'] == 'Delivered',
                      child: ElevatedButton(
                        onPressed: () {
                          // Assuming 'orderData' is a DocumentSnapshot
                          showDialog(
                            context: context,
                            builder: (context) {
                              double rate =
                                  1.0; // Initialize rate with a default value
                              String comment = ''; // Initial comment value

                              // Cast 'orderData' data to Map<String, dynamic>
                              Map<String, dynamic>? orderDataMap =
                                  widget.orderData.data()
                                      as Map<String, dynamic>?;

                              // Check if the 'orders' field exists and is a List
                              if (orderDataMap != null &&
                                  orderDataMap['orders'] is List) {
                                List<dynamic> orders =
                                    orderDataMap['orders'] as List<dynamic>;

                                String selectedProductId = orders.isNotEmpty
                                    ? orders[0]['productId']
                                    : ''; // Default to the first product

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Material(
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('Select Product for Review'),
                                            DropdownButton<String>(
                                              value: selectedProductId,
                                              items: orders.map((order) {
                                                return DropdownMenuItem<String>(
                                                  value: order['productId'],
                                                  child:
                                                      Text(order['orderName']),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedProductId = value!;
                                                });
                                              },
                                            ),
                                            RatingBar.builder(
                                              initialRating: rate,
                                              minRating: 1,
                                              allowHalfRating: true,
                                              itemBuilder: (context, _) {
                                                return Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              onRatingUpdate: (value) {
                                                setState(() {
                                                  rate = value;
                                                });
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Add a review',
                                                  labelText:
                                                      'Confirm the review',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    comment = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        Colors.purple.shade500,
                                                    child: MaterialButton(
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        Colors.purple.shade500,
                                                    child: MaterialButton(
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      onPressed: () async {
                                                        CollectionReference
                                                            reviewReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Products')
                                                                .doc(
                                                                    selectedProductId)
                                                                .collection(
                                                                    'reviews');

                                                        await reviewReference
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .set({
                                                          'name': orderDataMap[
                                                              'customerName'],
                                                          'email': orderDataMap[
                                                              'email'],
                                                          'rate': rate,
                                                          'comment': comment,
                                                        });

                                                        // Update user's coins
                                                        int coinsToAdd =
                                                            1; // You can adjust this based on your requirement

                                                        DocumentReference
                                                            userReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Customers')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid);

                                                        await userReference
                                                            .update({
                                                          'coins': FieldValue
                                                              .increment(
                                                                  coinsToAdd)
                                                        });

                                                        // // Assuming each order has a unique 'orderId'
                                                        // String orderId =
                                                        //     widget.orderData.id;

                                                        // await FirebaseFirestore
                                                        //     .instance
                                                        //     .collection(
                                                        //         'orders')
                                                        //     .doc(orderId)
                                                        //     .update({
                                                        //   'orderReview': true,
                                                        // });

                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              // Handle the case where 'productId' field is not present
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'The product ID is missing in the order data.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Add Review'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'รหัสคำสั่งซื้อ\n',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text:
                                  '# ${widget.orderData['orderId'].toString().substring(0, 10).padLeft(10, '0')}',
                              style: TextStyle(
                                color: Color(0xFF15161E),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF606A85),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'ขนส่ง\n',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: (widget.orderData['deliveryService'] ==
                                          null ||
                                      widget
                                          .orderData['deliveryService'].isEmpty)
                                  ? 'ยังไม่มีขนส่ง'
                                  : widget.orderData['deliveryService']!,
                              style: TextStyle(
                                color: Color(0xFF15161E),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF606A85),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tracking Number\n',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text:
                                  (widget.orderData['trackingNumber'] == null ||
                                          widget.orderData['trackingNumber']
                                              .isEmpty)
                                      ? 'ยังไม่มีเลขขนส่ง'
                                      : widget.orderData['trackingNumber'],
                              style: TextStyle(
                                color: Color(0xFF15161E),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF606A85),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 12)),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.orderData['orders'].length,
                itemBuilder: (context, index) {
                  var orderItem = widget.orderData['orders'][index];
                  return Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ชื่อสินค้า\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: orderItem['orderName'] ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'จำนวน\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: '${orderItem['orderQuantity']} ชิ้น',
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ราคา (ต่อหน่วย)\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: '${orderItem['orderPrice']} บาท',
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 12)),
                    ),
                  );
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข้อมูลที่อยู่ในการจัดส่ง',
                          style: TextStyle(
                            fontFamily: 'Kanit-Bold',
                            color: Color(0xFF606A85),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ].divide(SizedBox(height: 4)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ที่อยู่\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['address'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ตำบล\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['tumbon'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'อำเภอ\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['amphoe'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 12)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'จังหวัด\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['jangwhat'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'รหัสไปรณีย์\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['postCode'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 12)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'โน๊ต ....\n',
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: widget.orderData['noteAddress'],
                                  style: TextStyle(
                                    color: Color(0xFF15161E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                              style: TextStyle(
                                fontFamily: 'Kanit-Bold',
                                color: Color(0xFF606A85),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 12)),
                    ),
                  ),
                ],
              ),
            ].divide(SizedBox(height: 4)).addToEnd(SizedBox(height: 12)),
          ),
        ),
      ),
    );
  }
}
