// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckTrackingWidget extends StatefulWidget {
  const CheckTrackingWidget({Key? key, required this.orderData})
      : super(key: key);

  final QueryDocumentSnapshot<Object?> orderData;

  @override
  State<CheckTrackingWidget> createState() => _CheckTrackingWidgetState();
}

class _CheckTrackingWidgetState extends State<CheckTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    final deliverStatus = widget.orderData['deliverStatus'] as String?;

    final onConfirmed = widget.orderData['onconfirmed'] as bool? ?? false;
    final confirmDate = widget.orderData['confirmDate'] is Timestamp
        ? (widget.orderData['confirmDate'] as Timestamp).toDate().toString()
        : widget.orderData['confirmDate'] as String?;

    final prepareTranspot =
        widget.orderData['prepareTranspot'] as bool? ?? false;
    final prepareDate = widget.orderData['prepareDate'] is Timestamp
        ? (widget.orderData['prepareDate'] as Timestamp).toDate().toString()
        : widget.orderData['prepareDate'] as String?;

    final transpot = widget.orderData['transpot'] as bool? ?? false;
    final transpotDate = widget.orderData['transpotDate'] is Timestamp
        ? (widget.orderData['transpotDate'] as Timestamp).toDate().toString()
        : widget.orderData['transpotDate'] as String?;

    final delivered = widget.orderData['delivered'] as bool? ?? false;
    final deliveryDate = widget.orderData['deliveryDate'] is Timestamp
        ? (widget.orderData['deliveryDate'] as Timestamp).toDate().toString()
        : widget.orderData['deliveryDate'] as String?;

    // final inshipping = widget.orderData['inshipping'] as bool? ?? false;
    // // final inshippingDate = widget.orderData['inshipping'] is Timestamp
    // //     ? (widget.orderData['inshipping'] as Timestamp).toDate().toString()
    // //     : widget.orderData['inshipping'] as String?;

    final sorting = widget.orderData['Sorting'] as bool? ?? false;
    final sortingDate = widget.orderData['SortingDate'] is Timestamp
        ? (widget.orderData['SortingDate'] as Timestamp).toDate().toString()
        : widget.orderData['SortingDate'] as String?;

    final shipping = widget.orderData['shipping'] as bool? ?? false;
    final shippingDate = widget.orderData['shippingDate'] is Timestamp
        ? (widget.orderData['shippingDate'] as Timestamp).toDate().toString()
        : widget.orderData['shippingDate'] as String?;

    String statusMessage = '';
    DateTime? statusDate;

    if (onConfirmed) {
      statusMessage = 'ยืนยันคำสั่งซื้อแล้ว';
      statusDate = DateTime.tryParse(confirmDate ?? '');
    } else if (prepareTranspot) {
      statusMessage = 'เตรียมคำสั่งซื้อแล้ว';
      statusDate = DateTime.tryParse(prepareDate ?? '');
    } else if (transpot) {
      statusMessage = 'ร้านค้ามอบพัสดุให้ขนส่ง';
      statusDate = DateTime.tryParse(transpotDate ?? '');
    } else if (delivered) {
      statusMessage = 'มอบสินค้าเรียบร้อยแล้ว';
      statusDate = DateTime.tryParse(deliveryDate ?? '');
    // } else if (inshipping) {
    //   statusMessage = 'ขนส่งรับเข้าระบบ';
    //   // statusDate = DateTime.tryParse(inshippingDate ?? '');
    } else if (sorting) {
      statusMessage = 'ขนส่งกำลังคัดเเยกพัสดุ';
      statusDate = DateTime.tryParse(sortingDate ?? '');
    } else if (shipping) {
      statusMessage = 'ขนส่งกำลังนำส่งพัสดุให้คุณ';
      statusDate = DateTime.tryParse(shippingDate ?? '');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                    child: Text(
                      'ตรวจสอบสถานะคำสั่งซื้อ',
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'รหัสคำสั่งซื้อ ${(widget.orderData['orderId'].substring(0, 10))}',
                    style: TextStyle(
                      color: Color(0xFF18181B),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      bool currentStatus = false;
                      String currentStatusMessage = '';
                      DateTime? currentStatusDate;
                
                      switch (index) {
                        case 5:
                          currentStatus = onConfirmed;
                          currentStatusMessage = 'ยืนยันคำสั่งซื้อแล้ว';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                        case 4:
                          currentStatus = prepareTranspot;
                          currentStatusMessage = 'เตรียมคำสั่งซื้อแล้ว';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                        case 3:
                          currentStatus = transpot;
                          currentStatusMessage = 'ร้านค้ามอบพัสดุให้ขนส่ง';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                        // case 3:
                        //   currentStatus = inshipping;
                        //   currentStatusMessage = 'ขนส่งรับพัสดุ';
                        //   currentStatusDate = currentStatus ? statusDate : null;
                        //   break;
                        case 2:
                          currentStatus = sorting;
                          currentStatusMessage = 'ขนส่งกำลังคัดเเยกพัสดุ';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                        case 1:
                          currentStatus = shipping;
                          currentStatusMessage = 'ขนส่งกำลังนำส่งพัสดุให้คุณ';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                        case 0:
                          currentStatus = delivered;
                          currentStatusMessage = 'มอบสินค้าเรียบร้อยแล้ว';
                          currentStatusDate = currentStatus ? statusDate : null;
                          break;
                      }
                
                      // Check if the current status is true and the date is not null or empty
                      if (currentStatus && currentStatusDate != null) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE0E3E7),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 2,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE0E3E7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'CircularMall Express',
                                              style: TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 24,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'สถานะ :',
                                              style: TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 24,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  4, 0, 0, 0),
                                              child: Text(
                                                currentStatusMessage,
                                                style: TextStyle(
                                                  color: Color(0xFF4B39EF),
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'วันที่: ${DateFormat('dd/MM/yyyy').format(currentStatusDate)}',
                                          style: TextStyle(
                                            color: Color(0xFF57636C),
                                            fontSize: 24,
                                            fontWeight: FontWeight.normal,
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
                      } else {
                        return Container(); // Return an empty container if the status is false or the date is null or empty
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
