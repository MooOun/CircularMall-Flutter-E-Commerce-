import 'package:circularmallbc/Customers/MainScreen/SubScreen/CategoryProductScreen.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryCardWidget extends StatefulWidget {
  const CategoryCardWidget({Key? key, required this.category}) : super(key: key);
  final dynamic category;

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductScreen(category: widget.category),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF1F4F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 12, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.category['imageUrl'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                  child: Text(
                    widget.category['categoryName'] ?? '',
                    style: TextStyle(
                      color: Color(0xFF14181B),
                      fontSize: 22,
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
