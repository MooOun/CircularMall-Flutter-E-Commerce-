// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';
import 'package:circularmallbc/Components/ShowOrderDetailComponent.dart';
import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/OrderHistoryDetail.dart';
import 'package:circularmallbc/Customers/MainScreen/ProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart';

class OrderHistorysPageWidget extends StatefulWidget {
  const OrderHistorysPageWidget({Key? key}) : super(key: key);

  @override
  State<OrderHistorysPageWidget> createState() =>
      _OrderHistorysPageWidgetState();
}

class _OrderHistorysPageWidgetState extends State<OrderHistorysPageWidget>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String deliverStatus = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  Widget buildOrderListByStatus(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliverStatus', isEqualTo: status)
          .orderBy('orderDate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        int totalQuantity = 0;

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple.shade500,
            ),
          );
        }

        if (snapshot.hasData) {
          snapshot.data!.docs.forEach((document) {
            Map<String, dynamic> orderData =
                document.data() as Map<String, dynamic>;
            List<dynamic> ordersListDynamic = orderData['orders'];

            List<Map<String, dynamic>> ordersList = ordersListDynamic
                .map<Map<String, dynamic>>(
                    (order) => order as Map<String, dynamic>)
                .toList();

            totalQuantity += ordersList
                .map<int>((order) => order['orderQuantity'] as int)
                .reduce((sum, orderQuantity) => sum + orderQuantity);
          });
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final orderData = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderHistoryDetailWidget(
                              orderData: orderData,
                            ),
                          ),
                        );
                        print('Order item tapped: ${orderData['orderId']}');
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: 570,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    0,
                                    12,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textScaleFactor: MediaQuery.of(context)
                                            .textScaleFactor,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Order #: ',
                                              style: TextStyle(),
                                            ),
                                            TextSpan(
                                              text: orderData['orderId']
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                color: Color(0xFF6F61EF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                          style: TextStyle(
                                            color: Color(0xFF15161E),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          4,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'วันที่สั่งซื้อ: ${_formatTimestamp(orderData['orderDate'])}',
                                          style: TextStyle(
                                            color: Color(0xFF606A85),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'ยอดรวม ${orderData['totalOrderPrice'].toStringAsFixed(0)} บาท',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Color(0xFF15161E),
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          12,
                                          0,
                                          0,
                                        ),
                                        child: Container(
                                          height: 70,
                                          width: 331,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF1F4F8),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Color(0xFFE5E7EB),
                                              width: 2,
                                            ),
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                7,
                                                0,
                                                7,
                                                0,
                                              ),
                                              child: Row(
                                                children: [
                                                  // Display the image of the first product in the order
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      // Replace 'orderData' and 'products' with your actual variable names
                                                      orderData['orders'][0]
                                                          ['orderImage'],
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    orderData['orders'][0]
                                                        ['orderName'],
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                              0,
                                              12,
                                              0,
                                              0,
                                            ),
                                            child: Container(
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F4F8),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Color(0xFFE5E7EB),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                    7,
                                                    0,
                                                    7,
                                                    0,
                                                  ),
                                                  child: Text(
                                                    getOrderStatusText(
                                                        orderData[
                                                            'deliverStatus']),
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          if (orderData['deliverStatus'] ==
                                              'notconfirmed') // Add this condition
                                            SizedBox(
                                              width: 120,
                                              child: TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    deliverStatus =
                                                        'cancelOrder';
                                                    print(
                                                        'New deliverStatus: $deliverStatus');
                                                  });

                                                  // Assuming you have a reference to the current order's document
                                                  DocumentReference
                                                      orderDocument =
                                                      FirebaseFirestore.instance
                                                          .collection('Orders')
                                                          .doc(orderData.id);

                                                  // Update the Firestore document with the new deliverStatus
                                                  await orderDocument.update({
                                                    'deliverStatus':
                                                        'cancelOrder'
                                                  });

                                                  print(
                                                      'Firestore document updated!');
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    side: BorderSide(
                                                      color: Color(0xFFE5E7EB),
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 7),
                                                  child: Text(
                                                    'ยกเลิกคำสั่งซื้อ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        );
      },
    );
  }

  String getOrderStatusText(String deliverStatus) {
    switch (deliverStatus) {
      case 'notconfirmed':
        return 'ยังไม่ยืนยันคำสั่งซื้อ';
      case 'onconfirmed':
        return 'ยืนยันคำสั่งซื้อแล้ว';
      case 'preparetransport':
        return 'กำลังเตรียมคำสั่งซื้อ';
      case 'transport':
        return 'มอบให้ขนส่งแล้ว';
      case 'delivered':
        return 'รับสินค้าแล้ว';
      case 'cancelOrder':
        return 'ยกเลิกสินค้า';
      default:
        return deliverStatus; // Handle other cases as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF606A85),
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomHomeScreen(),
              ),
            );
            print('IconButton pressed ...');
          },
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                child: Text(
                  'คำสั่งซื้อของคุณ',
                  style: TextStyle(
                    color: Color(0xFF15161E),
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                child: Text(
                  'ด้านล่างนี้คือคำสั่งซื้อล่าสุดของคุณ.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0xFF606A85),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DefaultTabController(
                length: 6, // Update the length to 6
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'รอยืนยันคำสั่งซื้อ'),
                        Tab(text: 'ยืนยันคำสั่งซื้อแล้ว'),
                        Tab(text: 'เตรียมสินค้า'),
                        Tab(text: 'กำลังขนส่ง'),
                        Tab(text: 'สำเร็จ'),
                        Tab(text: 'ยกเลิกสินค้า'),
                      ],
                      indicatorColor: const Color.fromARGB(255, 33, 68, 243),
                      labelColor: const Color.fromARGB(255, 33, 68, 243),
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Kanit-Bold'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 1000, // Adjust the height as needed
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildOrderListByStatus('notconfirmed'),
                          buildOrderListByStatus('onconfirmed'),
                          buildOrderListByStatus('preparetransport'),
                          buildOrderListByStatus('transport'),
                          buildOrderListByStatus('delivered'),
                          buildOrderListByStatus('cancelOrder'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
