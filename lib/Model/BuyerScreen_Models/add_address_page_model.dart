
import 'package:circularmallbc/Customers/MainScreen/SubScreen/AddAddressScreen_Page.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAddressPageModel extends FlutterFlowModel<AddAddressPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(BuildContext, String?)? fullNameControllerValidator;
  // State field(s) for Phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  String? Function(BuildContext, String?)? phoneControllerValidator;
  // State field(s) for Address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressController;
  String? Function(BuildContext, String?)? addressControllerValidator;
  // State field(s) for Tumbon widget.
  FocusNode? tumbonFocusNode;
  TextEditingController? tumbonController;
  String? Function(BuildContext, String?)? tumbonControllerValidator;
  // State field(s) for Amphoe widget.
  FocusNode? amphoeFocusNode;
  TextEditingController? amphoeController;
  String? Function(BuildContext, String?)? amphoeControllerValidator;
  // State field(s) for Jangwhat widget.
  FocusNode? jangwhatFocusNode;
  TextEditingController? jangwhatController;
  String? Function(BuildContext, String?)? jangwhatControllerValidator;
  // State field(s) for PostCode widget.
  FocusNode? postCodeFocusNode;
  TextEditingController? postCodeController;
  String? Function(BuildContext, String?)? postCodeControllerValidator;
  // State field(s) for NoteAddress widget.
  FocusNode? noteAddressFocusNode;
  TextEditingController? noteAddressController;
  String? Function(BuildContext, String?)? noteAddressControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    phoneFocusNode?.dispose();
    phoneController?.dispose();

    addressFocusNode?.dispose();
    addressController?.dispose();

    tumbonFocusNode?.dispose();
    tumbonController?.dispose();

    amphoeFocusNode?.dispose();
    amphoeController?.dispose();

    jangwhatFocusNode?.dispose();
    jangwhatController?.dispose();

    postCodeFocusNode?.dispose();
    postCodeController?.dispose();

    noteAddressFocusNode?.dispose();
    noteAddressController?.dispose();
  }

  

  // String getCurrentUserId() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
