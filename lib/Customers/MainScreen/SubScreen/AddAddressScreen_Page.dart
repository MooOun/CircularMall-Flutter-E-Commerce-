// ignore_for_file: prefer_const_constructors

import 'package:circularmallbc/Customers/MainScreen/ManageAddressScreen_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../Model/BuyerScreen_Models/add_address_page_model.dart';
export '../../../Model/BuyerScreen_Models/add_address_page_model.dart';

class AddAddressPageWidget extends StatefulWidget {
  const AddAddressPageWidget({super.key});

  @override
  State<AddAddressPageWidget> createState() => _AddAddressPageWidgetState();
}

class _AddAddressPageWidgetState extends State<AddAddressPageWidget> {
  late AddAddressPageModel _model;
  String selectedAddressPosition = '';
  bool isHomeSelected = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAddressPageModel());

    _model.fullNameController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.phoneController ??= TextEditingController();
    _model.phoneFocusNode ??= FocusNode();

    _model.addressController ??= TextEditingController();
    _model.addressFocusNode ??= FocusNode();

    _model.tumbonController ??= TextEditingController();
    _model.tumbonFocusNode ??= FocusNode();

    _model.amphoeController ??= TextEditingController();
    _model.amphoeFocusNode ??= FocusNode();

    _model.jangwhatController ??= TextEditingController();
    _model.jangwhatFocusNode ??= FocusNode();

    _model.postCodeController ??= TextEditingController();
    _model.postCodeFocusNode ??= FocusNode();

    _model.noteAddressController ??= TextEditingController();
    _model.noteAddressFocusNode ??= FocusNode();
  }

  Future<void> saveAddressToFirestore(String addressPosition) async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // User is not logged in, show a message or navigate to the login page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เข้าสู่ระบบก่อน')),
        );
        return;
      }

      String uid = user.uid;
      String addressId = Uuid().v4(); // Generate a UUID for the address

      // Create a reference to the user's collection
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('Customers');

      // Create a reference to the user's specific document
      DocumentReference userDocument = userCollection.doc(uid);

      // Create a reference to the addresses subcollection
      CollectionReference addressesCollection =
          userDocument.collection('addresses');

      // Save the address data to Firestore
      await addressesCollection.doc(addressId).set({
        'addressId': addressId,
        'uid': uid, // Store the uid in the document
        'addressPosition': selectedAddressPosition,
        'addressStatus': true, // Set addressStatus to true for the new address
        'fullName': _model.fullNameController.text,
        'phone': _model.phoneController.text,
        'address': _model.addressController.text,
        'tumbon': _model.tumbonController.text,
        'amphoe': _model.amphoeController.text,
        'jangwhat': _model.jangwhatController.text,
        'postCode': _model.postCodeController.text,
        'noteAddress': _model.noteAddressController.text,
      });

      // Set addressStatus to false for all other addresses
      await addressesCollection
          .where('addressPosition', isEqualTo: addressPosition)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          if (doc.id != addressId) {
            doc.reference.update({'addressStatus': false});
          }
        });
      });

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกที่อยู่เรียบร้อยแล้ว')),
      );
    } catch (e) {
      // Handle errors
      print('เกิดข้อผิดพลาดในการบันทึกที่อยู่: $e');
    }
  }

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
              color: Color(0xFF15161E),
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);

              print('IconButton pressed ...');
            },
          ),
          title: Text(
            'เพิ่มที่อยู่ในการจัดส่ง',
            style: TextStyle(
              color: Color(0xFF15161E),
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text(
                      'เพิ่มที่อยู่ของคุณ',
                      style: TextStyle(
                        color: Color(0xFF15161E),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: IconButton(
                            onPressed: () {
                              print('บ้าน');
                              selectedAddressPosition = 'บ้าน';
                            },
                            icon: Container(
                              width: 120,
                              constraints: BoxConstraints(
                                maxWidth: 500,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE5E7EB),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8, 16, 8, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 36,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        'บ้าน',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF15161E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: IconButton(
                            onPressed: () {
                              print('ที่ทำงาน');
                              selectedAddressPosition = 'ที่ทำงาน';
                            },
                            icon: Container(
                              width: 120,
                              constraints: BoxConstraints(
                                maxWidth: 500,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE5E7EB),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8, 16, 8, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_post_office,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 36,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        'ที่ทำงาน',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF15161E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: IconButton(
                            onPressed: () {
                              print('อื่นๆ');
                              selectedAddressPosition = 'อื่นๆ';
                            },
                            icon: Container(
                              width: 120,
                              constraints: BoxConstraints(
                                maxWidth: 500,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE5E7EB),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8, 16, 8, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 36,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        'อื่นๆ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF15161E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12)),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: _model.fullNameController,
                          focusNode: _model.fullNameFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'ชื่อ - สกุล',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.fullNameControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.phoneController,
                          focusNode: _model.phoneFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'เบอร์โทรศัพท์',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.phone,
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.phoneControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.addressController,
                          focusNode: _model.addressFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'ที่อยู่ของคุณ',
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.addressControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.tumbonController,
                          focusNode: _model.tumbonFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'ตำบล',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.tumbonControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.amphoeController,
                          focusNode: _model.amphoeFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'อำเภอ',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.amphoeControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.jangwhatController,
                          focusNode: _model.jangwhatFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'จังหวัด',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.jangwhatControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.postCodeController,
                          focusNode: _model.postCodeFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'รหัสไปรณีย์',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.postCodeControllerValidator
                              .asValidator(context),
                        ),
                        TextFormField(
                          controller: _model.noteAddressController,
                          focusNode: _model.noteAddressFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'โน๊ต ...',
                            labelStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF606A85),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6F61EF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFF5963),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          ),
                          style: TextStyle(
                            color: Color(0xFF15161E),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Color(0xFF6F61EF),
                          validator: _model.noteAddressControllerValidator
                              .asValidator(context),
                        ),
                      ].divide(SizedBox(height: 12)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                    child: FFButtonWidget(
                      onPressed: () {
                        saveAddressToFirestore('บ้าน');
                        print('Button pressed ...');
                      },
                      text: 'บันทึกที่อยู่ของฉัน',
                      icon: FaIcon(
                        FontAwesomeIcons.pushed,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48,
                        padding: EdgeInsets.all(0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).alternate,
                        textStyle: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 4,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
