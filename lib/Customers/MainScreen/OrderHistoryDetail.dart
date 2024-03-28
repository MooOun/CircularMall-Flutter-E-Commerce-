// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:circularmallbc/Customers/MainScreen/CheckingTrack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderHistoryDetailWidget extends StatefulWidget {
  const OrderHistoryDetailWidget({super.key, required this.orderData});

  final QueryDocumentSnapshot<Object?> orderData;

  @override
  State<OrderHistoryDetailWidget> createState() =>
      _OrderHistoryDetailWidgetState();
}

Future<String> uploadImage(File imageFile) async {
  String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
  Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
  UploadTask uploadTask = storageReference.putFile(imageFile);
  await uploadTask.whenComplete(() => null);
  String imageUrl = await storageReference.getDownloadURL();
  return imageUrl;
}

class _OrderHistoryDetailWidgetState extends State<OrderHistoryDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
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
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
             
            },
          ),
          title: Text(
            'รายละเอียดคำสั่งซื้อ',
            style: TextStyle(
              color: Color(0xFF15161E),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0, -1),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 1170,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: 1170,
                            ),
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 10, 0, 0),
                                  child: Text(
                                    'รหัสคำสั่งซื้อ ${(widget.orderData['orderId'].substring(0, 10))}',
                                    style: TextStyle(
                                      color: Color(0xFF15161E),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 4, 0, 0),
                                  child: Text(
                                    'ด้านล่างนี้เป็นรายละเอียดคำสั่งซื้อของคุณ.',
                                    style: TextStyle(
                                      color: Color(0xFF606A85),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Orders')
                                      .where('orderId',
                                          isEqualTo:
                                              widget.orderData['orderId'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator(); 
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final orderData =
                                            snapshot.data!.docs[index];

                                        return Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckTrackingWidget(
                                                    orderData: orderData,
                                                  ),
                                                ),
                                              );
                                              print('TextButton pressed ...');
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  width: 1,
                                                ),
                                              ),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'สินค้าของคุณจะถึงภายในวันที่ ${DateFormat('dd/MMM').format(widget.orderData['orderDate'].toDate().add(Duration(days: 4)))} - ${DateFormat('dd/MMM').format(widget.orderData['orderDate'].toDate().add(Duration(days: 6)))} ',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.navigate_next,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, -1),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                width: double.infinity,
                                // constraints: BoxConstraints(
                                //   maxWidth: 1170,
                                // ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 0, 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'รายละเอียดคำสั่งซื้อ',
                                              style: TextStyle(
                                                color: Color(0xFF15161E),
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Visibility(
                                                    visible: widget.orderData[
                                                            'deliverStatus'] ==
                                                        'delivered',
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            double rate = 1.0;
                                                            String comment = '';
                                                            String
                                                                selectedProductId =
                                                                '';
                                                            File? imageFile;

                                                            Map<String,
                                                                    dynamic>?
                                                                orderDataMap =
                                                                widget.orderData
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>?;

                                                            
                                                            if (orderDataMap !=
                                                                    null &&
                                                                orderDataMap[
                                                                        'orders']
                                                                    is List) {
                                                              List<dynamic>
                                                                  orders =
                                                                  orderDataMap[
                                                                          'orders']
                                                                      as List<
                                                                          dynamic>;

                                                              selectedProductId =
                                                                  orders.isNotEmpty
                                                                      ? orders[
                                                                              0]
                                                                          [
                                                                          'productId']
                                                                      : '';

                                                              return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                                  return Material(
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                              'เลือกสินค้าเพื่อรีวิว'),

                                                                          DropdownButton<
                                                                              String>(
                                                                            value:
                                                                                selectedProductId,
                                                                            items:
                                                                                orders.map((order) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: order['productId'],
                                                                                child: Text(order['orderName']),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                selectedProductId = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              // Use image_picker to allow the user to choose an image
                                                                              final picker = ImagePicker();
                                                                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                                                              if (pickedFile != null) {
                                                                                setState(() {
                                                                                  imageFile = File(pickedFile.path);
                                                                                });
                                                                              }
                                                                            },
                                                                            child: imageFile != null
                                                                                ? Image.file(
                                                                                    imageFile!,
                                                                                    height: 100,
                                                                                    width: 100,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.add_a_photo,
                                                                                    size: 50,
                                                                                  ),
                                                                          ),
                                                                          RatingBar
                                                                              .builder(
                                                                            initialRating:
                                                                                rate,
                                                                            minRating:
                                                                                1,
                                                                            allowHalfRating:
                                                                                true,
                                                                            itemBuilder:
                                                                                (context, _) {
                                                                              return Icon(
                                                                                Icons.star,
                                                                                color: Colors.amber,
                                                                              );
                                                                            },
                                                                            onRatingUpdate:
                                                                                (value) {
                                                                              setState(() {
                                                                                rate = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                          SingleChildScrollView(
                                                                          child:Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                TextField(
                                                                              decoration: InputDecoration(
                                                                                hintText: 'เพิ่มรีวิว',
                                                                                labelText: 'เพิ่มการรีวิว',
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                              ),
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  comment = value;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                          ),
                                                                          // Image selection and preview
                                                                          
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(15.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Material(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: Colors.white24,
                                                                                  child: MaterialButton(
                                                                                    minWidth: MediaQuery.of(context).size.width * 0.45,
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      'ยกเลิก',
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Material(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: Colors.white24,
                                                                                  child: MaterialButton(
                                                                                    minWidth: MediaQuery.of(context).size.width * 0.45,
                                                                                    onPressed: () async {
                                                                                      CollectionReference reviewReference = FirebaseFirestore.instance.collection('Products').doc(selectedProductId).collection('reviews');

                                                                                      // Upload image to Firebase Storage
                                                                                      String imageUrl = '';
                                                                                      if (imageFile != null) {
                                                                                        imageUrl = await uploadImage(imageFile!);
                                                                                      }

                                                                                      // Save review data to Firestore
                                                                                      await reviewReference.doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                        'name': orderDataMap['customerName'],
                                                                                        'email': orderDataMap['email'],
                                                                                        'rate': rate,
                                                                                        'comment': comment,
                                                                                        'imageUrl': imageUrl,
                                                                                      });

                                                                                      // Update user's coins
                                                                                      int coinsToAdd = 1;
                                                                                      DocumentReference userReference = FirebaseFirestore.instance.collection('Customers').doc(FirebaseAuth.instance.currentUser!.uid);

                                                                                      await userReference.update({
                                                                                        'coins': FieldValue.increment(coinsToAdd)
                                                                                      });

                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      'OK',
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
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
                                                              title:
                                                                  Text('Error'),
                                                              content: Text(
                                                                  'The product ID is missing in the order data.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                          'เพิ่มรีวิวสินค้า'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: FFButtonWidget(
                                                      onPressed: () {
                                                        print(
                                                            'Button pressed ...');
                                                      },
                                                      text: () {
                                                        if (widget.orderData[
                                                                'deliverStatus'] ==
                                                            'notconfirmed') {
                                                          return 'ยังไม่ได้ยืนยันคำสั่งซื้อ';
                                                        } else if (widget
                                                                    .orderData[
                                                                'deliverStatus'] ==
                                                            'onconfirmed') {
                                                          return 'ยืนยันคำสั่งซื้อแล้ว';
                                                        } else if (widget
                                                                    .orderData[
                                                                'deliverStatus'] ==
                                                            'preparetransport') {
                                                          return 'เตรียมสินค้าเพื่อมอบให้ขนส่ง';
                                                        } else if (widget
                                                                    .orderData[
                                                                'deliverStatus'] ==
                                                            'transport') {
                                                          return 'มอบสินค้าให้กับขนส่งแล้ว';
                                                        } else if (widget
                                                                    .orderData[
                                                                'deliverStatus'] ==
                                                            'delivered') {
                                                          return 'ผู้รับได้รับสินค้าเเล้ว';
                                                        }
                                                        else if (widget
                                                                    .orderData[
                                                                'deliverStatus'] ==
                                                            'cancelOrder') {
                                                          return 'ยกเลิกสินค้า';
                                                        } else {
                                                          
                                                          return '';
                                                        }
                                                      }(),
                                                      options: FFButtonOptions(
                                                        height: 40,
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(24, 0,
                                                                    24, 0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 0, 0, 0),
                                                        color:
                                                            Color(0xFF6F61EF),
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        elevation: 3,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'หมายเลขคำสั่งซื้อ',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      (widget
                                                          .orderData['orderId']
                                                          .substring(0, 12)),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'วันที่สั่งซื้อ',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      DateFormat(
                                                              'dd-MMM-yyyy HH:mm:ss')
                                                          .format(widget
                                                              .orderData[
                                                                  'orderDate']
                                                              .toDate()),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'วิธีการชำระเงิน',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData[
                                                          'paymentStatus'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'หมายเลขติดตามพัสดุ',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget
                                                              .orderData[
                                                                  'trackingNumber']
                                                              .isEmpty
                                                          ? 'ยังไม่มีเลขพัสดุ'
                                                          : widget.orderData[
                                                              'trackingNumber'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 16, 0, 5),
                                              child: Divider(
                                                thickness: 2,
                                                color: Color(0xFFE5E7EB),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 10, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 12),
                                                    child: Text(
                                                      'รายละเอียดสินค้า',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF606A85),
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                        .orderData['orders']
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var orderItem =
                                                          widget.orderData[
                                                              'orders'][index];

                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 0,
                                                                    0, 12),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFE5E7EB),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              12),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            66,
                                                                        height:
                                                                            66,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0xFFE5E7EB),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                          child:
                                                                              Image.network(
                                                                            orderItem['orderImage'],
                                                                            width:
                                                                                66,
                                                                            height:
                                                                                66,
                                                                            fit:
                                                                                BoxFit.cover,
                                            
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              orderItem['orderName'],
                                                                              style: TextStyle(
                                                                                color: Color(0xFF15161E),
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                                              child: Text(
                                                                                'ราคา : ${(orderItem['orderPrice'].toStringAsFixed(0))} บาท',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF6F61EF),
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                                              child: Text(
                                                                                'จำนวน : ${(orderItem['orderQuantity'].toStringAsFixed(0))} ชิ้น',
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF6F61EF),
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
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
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 16, 0, 16),
                                              child: Divider(
                                                thickness: 2,
                                                color: Color(0xFFE5E7EB),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 12),
                                              child: Text(
                                                'สรุปคำสั่งซื้อ',
                                                style: TextStyle(
                                                  color: Color(0xFF15161E),
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'ยอดรวม',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      '${(widget.orderData['totalOrderPrice'].toStringAsFixed(0))} บาท',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'รวมทั้งหมด',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      '${(widget.orderData['totalOrderPrice'].toStringAsFixed(0))} บาท',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineSmall
                                                          .override(
                                                            fontFamily:
                                                                'Outfit',
                                                            color: Color(
                                                                0xFF15161E),
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 16, 0, 16),
                                              child: Divider(
                                                thickness: 2,
                                                color: Color(0xFFE5E7EB),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 12),
                                              child: Text(
                                                'ที่อยู่จัดส่ง',
                                                style: TextStyle(
                                                  color: Color(0xFF15161E),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'ชื่อ',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData[
                                                          'customerName'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'เบอร์โทร',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData['phone'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'ที่อยู่',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget
                                                          .orderData['address'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'ตำบล',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget
                                                          .orderData['tumbon'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'อำเภอ',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget
                                                          .orderData['amphoe'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'จังหวัด',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData[
                                                          'jangwhat'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'รหัสไปรณีย์',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData[
                                                          'postCode'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 8, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'โน๊ต..',
                                                    style: TextStyle(
                                                      color: Color(0xFF606A85),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      widget.orderData[
                                                          'noteAddress'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF15161E),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                  ].divide(SizedBox(width: 16)),
                                ),
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
    );
  }
}
