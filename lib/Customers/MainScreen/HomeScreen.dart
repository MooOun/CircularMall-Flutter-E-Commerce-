// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Components/BestSellingCard.dart';
import 'package:circularmallbc/Components/ProductCard.dart';
import 'package:circularmallbc/Customers/MainScreen/CartScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/Searchscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  static const String routeName = 'HomeScreen';
}

class _HomeScreenState extends State<HomeScreen> {

   late bool _sortAscending;
  late Stream<QuerySnapshot> _dailyproductsStream;

  final Stream<QuerySnapshot> _bestproductsStream = FirebaseFirestore.instance
      .collection('Products')
      .where('soldCount', isGreaterThan: 100)
      .snapshots();

  // final Stream<QuerySnapshot> _dailyproductsStream =
  //     FirebaseFirestore.instance.collection('Products').snapshots();

  @override
  void initState() {
    super.initState();
    _sortAscending = true;
    _dailyproductsStream =
        FirebaseFirestore.instance.collection('Products').snapshots();
  }

  Future<void> _showSortDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort By'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Handle sorting by price ascending
                    _sortProductsByPrice(true);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('เรียงจากราคา - ต่ำ ไป สูง', style: TextStyle(fontSize: 24),),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle sorting by price descending
                    _sortProductsByPrice(false);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('เรียงจากราคา - สูง ไป ต่ำ', style: TextStyle(fontSize: 24),),
                ),
                // Add more sorting options as needed
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to fetch and sort products by price
  void _sortProductsByPrice(bool ascending) {
    setState(() {
      _sortAscending = ascending;
      _dailyproductsStream = FirebaseFirestore.instance
          .collection('Products')
          .orderBy('price', descending: !_sortAscending)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color(0xFFF1F4F8),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: 500,
                child: Stack(
                  alignment: AlignmentDirectional(0, -1),
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.05, -1),
                      child: Image.network(
                        'https://down-aka-th.img.susercontent.com/th-11134210-7r98u-lr0c9fepifsec9.webp',
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                        alignment: Alignment(0, 0),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Color(0x8D090F13),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 60, 16, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return SearchScreen();
                                        }));
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        hintText: 'คุณกำลังหาอะไรอยู่ ...',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Color(0xFF14181B),
                                          size: 16,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF14181B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: 15,
                                    borderWidth: 1,
                                    buttonSize: 65,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    icon: Icon(
                                      Icons.shopping_basket_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CartScreenPageWidget()),
                                      );
                                    },
                                  ),
                                ].divide(SizedBox(width: 5)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 24, 16, 44),
                              child: Text(
                                'Believe In Circular Economy By Using Sustainable Resources',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 33,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 700,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 24),
                                  child: SingleChildScrollView(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(
                                            height: 8,
                                            thickness: 4,
                                            indent: 140,
                                            endIndent: 140,
                                            color: Color(0xFFE0E3E7),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 16, 16, 0),
                                            child: Text(
                                              'สินค้าขายดีของเรา',
                                              style: TextStyle(
                                                color: Color(0xFF14181B),
                                                fontSize: 36,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 0, 16, 0),
                                            child: Text(
                                              'สินค้าขายดีประจำเดือน มีนาคม',
                                              style: TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: _bestproductsStream,
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
                                                    color: Colors.purple,
                                                  ),
                                                );
                                              }

                                              if (snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                  child: Text(
                                                    'ยังไม่มีสินค้าขายดีในปัจจุบัน',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors
                                                          .purple.shade300,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Container(
                                                  width: 320,
                                                  height: 320,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return BestSellingCardComponentWidget(
                                                        products: snapshot
                                                            .data!.docs[index],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: _dailyproductsStream,
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
                                                    color: Colors.purple,
                                                  ),
                                                );
                                              }

                                              if (snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                  child: Text(
                                                    'ยังไม่มีสินค้าขายดีในปัจจุบัน',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors
                                                          .purple.shade300,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16,
                                                                        16,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              'สินค้าแนะนำประจำวัน',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 36,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.sort),
                                                                onPressed: () {
                                                                  // Handling onPressed for sorting
                                                                  _showSortDialog();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16,
                                                                        0,
                                                                        16,
                                                                        0),
                                                            child: Text(
                                                              'สินค้าแนะนำวันนี้',
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
                                                        ],
                                                      ),
                                                      GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 4.0,
                                                          mainAxisSpacing: 8.0,
                                                        ),
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ProductCardComponentWidget(
                                                            products: snapshot
                                                                .data!
                                                                .docs[index],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
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
            ),
          ],
        ),
      ),
    );
  }
}
