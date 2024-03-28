// ignore_for_file: prefer_const_constructors

import 'package:circularmallbc/Customers/MainScreen/ProductDetailScreen.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BestSellingCardComponentWidget extends StatefulWidget {
  final dynamic products;
  const BestSellingCardComponentWidget({super.key, this.products});

  @override
  State<BestSellingCardComponentWidget> createState() =>
      _BestSellingCardComponentWidgetState();
}

class _BestSellingCardComponentWidgetState
    extends State<BestSellingCardComponentWidget> {
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreenWidget(productList: widget.products),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 12),
        child: Container(
          width: 249,
          height: 288,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Color(0x230F1113),
                offset: Offset(0, 4),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFF1F4F8),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  widget.products['imgProduct'][0],
                  width: double.infinity,
                  height: 213,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.products['productName'] ?? '',
                          style:TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RatingBarIndicator(
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Color(0xFF14181B),
                                ),
                                direction: Axis.horizontal,
                                rating: 4,
                                unratedColor: Color(0xFF57636C),
                                itemCount: 5,
                                itemSize: 16,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                child: Text(
                                  '4.7',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF14181B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFF14181B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: Text(
                          (widget.products['price'] ?? 0.0)
                                        .toStringAsFixed(2) +
                                    ' บาท ',
                          style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
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
    );
  }
}
