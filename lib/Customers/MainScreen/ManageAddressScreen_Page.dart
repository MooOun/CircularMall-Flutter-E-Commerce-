// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/AddAddressScreen_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Model/BuyerScreen_Models/manage_address_screen_page_model.dart';
export '../../Model/BuyerScreen_Models/manage_address_screen_page_model.dart';

class ManageAddressScreenPageWidget extends StatefulWidget {
  const ManageAddressScreenPageWidget({super.key});

  @override
  State<ManageAddressScreenPageWidget> createState() =>
      _ManageAddressScreenPageWidgetState();
}

class _ManageAddressScreenPageWidgetState
    extends State<ManageAddressScreenPageWidget> {
  late ManageAddressScreenPageModel _model;
  int? _selectedAddressIndex;
  String addressId = "your_actual_address_id";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageAddressScreenPageModel());
    // Fetch and display user-specific addresses
    getUserAddresses().then((addresses) {
      // Use the fetched addresses as needed, for example:
      print('Number of addresses: ${addresses.length}');
      // Update the count in the state or wherever you want to use it
      setState(() {
        _model.addressCount = addresses.length;
        _model.addressesList =
            addresses; // Assuming you have a variable in your model to store addresses
      });
    });
  }

  Future<List<Map<String, dynamic>>> getUserAddresses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is not signed in.');
      return [];
    }

    // Reference to the 'Customer' collection
    CollectionReference customerCollection =
        FirebaseFirestore.instance.collection('Customers');

    // Reference to the 'addresses' subcollection for the current user
    CollectionReference addressesCollection =
        customerCollection.doc(user.uid).collection('addresses');

    // Query addresses for the current user
    QuerySnapshot addressesSnapshot = await addressesCollection.get();

    List<Map<String, dynamic>> addressesList = [];

    print('Number of documents found: ${addressesSnapshot.docs.length}');

    addressesSnapshot.docs.forEach((doc) {
      Map<String, dynamic> addressData = doc.data() as Map<String, dynamic>;
      addressesList.add(addressData);
    });

    return addressesList;
  }

  // Assuming addressId is a string

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
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 10, 0, 0),
            child: Text(
              'จัดการที่อยู่',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
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
              children: [
                // Container(
                //   width: double.infinity,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     color: Color(0xFF4B39EF),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                //     child: Text(
                //       'จัดการที่อยู่',
                //       textAlign: TextAlign.start,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 26,
                //         fontWeight: FontWeight.normal,
                //       ),
                //     ),
                //   ),
                // ),
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x2D101213),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'ที่อยู่ (${_model.addressCount ?? 0} ที่)',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 0),
                                  child: Text(
                                    'เพิ่มที่อยู่',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Color(0xFF14181B),
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF57636C),
                                  size: 24,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddAddressPageWidget()));
                                },
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _model.addressesList?.length ?? 0,
                          itemBuilder: (context, index) {
                            final address = _model.addressesList![index];

                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors
                                        .grey, // You can adjust the border color
                                    width: 1, // You can adjust the border width
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: Color(0x25090F13),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${address['fullName'] ?? 'Default Full Name'}',
                                            style: TextStyle(
                                              fontFamily: 'Kanit-Bold',
                                              color: Color(0xFF14181B),
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: index,
                                                groupValue:
                                                    _selectedAddressIndex,
                                                onChanged: (int? value) async {
                                                  setState(() {
                                                    _selectedAddressIndex =
                                                        value;
                                                  });

                                                  // Update addressStatus in Firestore
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Customers')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .collection('addresses')
                                                      .doc(address[
                                                          'addressId']) // Assuming you have an 'addressId' field
                                                      .update({
                                                    'addressStatus': true
                                                  });

                                                  // Set other addresses to false
                                                  for (int i = 0;
                                                      i <
                                                          _model.addressesList!
                                                              .length;
                                                      i++) {
                                                    if (i != index) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Customers')
                                                          .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser !=
                                                                  null
                                                              ? FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                              : 'Default UID')
                                                          .collection(
                                                              'addresses')
                                                          .doc(_model
                                                                  .addressesList![
                                                              i]['addressId'])
                                                          .update({
                                                        'addressStatus': false
                                                      });
                                                    }
                                                  }

                                                  // Fetch and display updated addresses
                                                  getUserAddresses()
                                                      .then((addresses) {
                                                    setState(() {
                                                      _model.addressCount =
                                                          addresses.length;
                                                      _model.addressesList =
                                                          addresses;
                                                    });
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'เบอร์ตืดต่อ: ${address['phone'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'ที่อยู่: ${address['address'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'ตำบล: ${address['tumbon'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'อำเภอ: ${address['amphoe'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'จังหวัด: ${address['jangwhat'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'รหัสไปรณีย์: ${address['postCode'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'โน๊ต...: ${address['noteAddress'] ?? 'Default Address'}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit-Bold',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ตำเเหน่ง:',
                                            style: TextStyle(
                                              fontFamily: 'Kanit-Bold',
                                              color: Color(0xFF14181B),
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8, 0, 0, 0),
                                              child: Text(
                                                address['addressPosition'] ??
                                                    'Default Address Position',
                                                style: TextStyle(
                                                  fontFamily: 'Kanit-Bold',
                                                  color: Color(0xFF4B39EF),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF1F4F8),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Text(
                                              address['addressStatus'] == true
                                                  ? 'เลือกแล้ว'
                                                  : 'ยังไม่ได้เลือก',
                                              style: TextStyle(
                                                fontFamily: 'Kanit-Bold',
                                                color: Color(0xFF14181B),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
