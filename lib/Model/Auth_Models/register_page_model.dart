
import 'package:circularmallbc/Auth/RegisterScreen.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPageModel extends FlutterFlowModel<RegisterPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)? passwordConfirmControllerValidator;
  // State field(s) for CustomerName widget.
  FocusNode? customerNameFocusNode;
  TextEditingController? customerNameController;
  String? Function(BuildContext, String?)? customerNameControllerValidator;
  // State field(s) for CustomerPhone widget.
  FocusNode? customerPhoneFocusNode;
  TextEditingController? customerPhoneController;
  String? Function(BuildContext, String?)? customerPhoneControllerValidator;

  /// Initialization and disposal methods.
  /// 

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordConfirmVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmController?.dispose();

    customerNameFocusNode?.dispose();
    customerNameController?.dispose();

    customerPhoneFocusNode?.dispose();
    customerPhoneController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
