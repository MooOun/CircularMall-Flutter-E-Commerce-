// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class EditProfileScreenPageWidget extends StatefulWidget {
  const EditProfileScreenPageWidget({Key? key}) : super(key: key);

  @override
  State<EditProfileScreenPageWidget> createState() =>
      _EditProfileScreenPageWidgetState();
}

class _EditProfileScreenPageWidgetState
    extends State<EditProfileScreenPageWidget> {
  TextEditingController _nameController = TextEditingController();
  String _imageUrl = '';
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 50,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF14181B),
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print('IconButton pressed ...');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                    child: Text(
                      'แก้ไขบัญชีผู้ใช้งาน',
                      style:TextStyle(
                        color: Color(0xFF14181B),
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFE0E3E7),
                      shape: BoxShape.circle,
                    ),
                    child: _pickedImage != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(_pickedImage!.path)),
                            radius: 50,
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
              child: TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'ชื่อของคุณ..',
                  labelStyle: TextStyle(
                    
                    color: Color(0xFF57636C),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  hintStyle: TextStyle(
                    
                    color: Color(0xFF57636C),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E3E7),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF4B39EF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: TextStyle(
                 
                  color: Color(0xFF14181B),
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: FFButtonWidget(
                  onPressed: _updateProfile,
                  text: 'บันทึก',
                  options: FFButtonOptions(
                    width: 270,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFF4B39EF),
                    textStyle:
                       TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                    elevation: 2,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle image picking
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Reference to the 'Customers' collection
        CollectionReference customersCollection =
            FirebaseFirestore.instance.collection('Customers');

        // Reference to the document with the user's UID
        DocumentReference userDocument = customersCollection.doc(user.uid);

        // Upload image to Firebase Storage and get the download URL
        String imageUrl = await _uploadImageToStorage(user.uid);

        // Update the fields in the document
        await userDocument.update({
          'customerName': _nameController.text,
          'imageUrl': imageUrl,
        });

        print('User information updated successfully.');
      } catch (e) {
        print('Error updating user information: $e');
      }
    }
  }

  Future<String> _uploadImageToStorage(String userId) async {
    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Customers/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(File(_pickedImage!.path));

      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }
}
