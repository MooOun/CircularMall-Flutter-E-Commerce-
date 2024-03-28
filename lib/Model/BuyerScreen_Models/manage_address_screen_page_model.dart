
import 'package:circularmallbc/Customers/MainScreen/ManageAddressScreen_Page.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddressModel {
  final String address;
  final String addressId;
  final String fullName;
  final String addressPosition;
  final String addressStatus;
  final String amphoe;
  final String jangwhat;
  final String phone;
  final String postCode;
  final String tumbon;
  final String noteAddress;

  AddressModel({
    required this.address,
    required this.addressId,
    required this.fullName,
    required this.addressPosition,
    required this.addressStatus,
    required this.amphoe,
    required this.jangwhat,
    required this.phone,
    required this.postCode,
    required this.tumbon,
    required this.noteAddress,
  });
}

class ManageAddressScreenPageModel
    extends FlutterFlowModel<ManageAddressScreenPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue;
  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;
  int? addressCount; // Add this line
  List<Map<String, dynamic>>? addressesList;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

   void updateAddresses(List<AddressModel> addresses) {
  _addresses = addresses;
  
}


  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
