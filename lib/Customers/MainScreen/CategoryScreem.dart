// ignore_for_file: prefer_const_constructors

import 'package:circularmallbc/Components/CategoryCard.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/CategorySearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryScreenWidget extends StatefulWidget {
  const CategoryScreenWidget({super.key});

  @override
  State<CategoryScreenWidget> createState() => _CategoryScreenWidgetState();
}

class _CategoryScreenWidgetState extends State<CategoryScreenWidget> {
  final Stream<QuerySnapshot> _categoryStream =
      FirebaseFirestore.instance.collection('Categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'หมวดหมู่สินค้า',
            style: TextStyle(
                  color: Color(0xFF14181B),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 8, 0),
                      child: TextFormField(
                        onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return CategorySearchScreen();
                                        }));
                                      },
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'ค้นหาหมวดหมู่สินค้า...',
                          labelStyle:
                              TextStyle(
                                    color: Color(0xFF57636C),
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal,
                                  ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFE0E3E7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF4B39EF),
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
                          filled: true,
                          fillColor: Color(0xFFF1F4F8),
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF57636C),
                            size: 16,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF14181B),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 12, 0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      buttonSize: 50,
                      icon: Icon(
                        Icons.search_sharp,
                        color: Color(0xFF14181B),
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                      child: Text(
                        'Categories',
                        style:
                            TextStyle(
                                  color: Color(0xFF14181B),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _categoryStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Something went wrong'),
                          );
                        }
                
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.purple,
                            ),
                          );
                        }
                
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'ยังไม่มีหมวดหมู่สินค้า',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.purple.shade300,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        }
                
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Container(
                            width: double.infinity,
                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return CategoryCardWidget(
                                    category: snapshot.data!.docs[index],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
