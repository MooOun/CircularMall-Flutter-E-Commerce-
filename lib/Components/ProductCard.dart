import 'package:circularmallbc/Customers/MainScreen/ProductDetailScreen.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class ProductCardComponentWidget extends StatefulWidget {
  const ProductCardComponentWidget({super.key, this.products});
  final dynamic products;

  @override
  State<ProductCardComponentWidget> createState() =>
      _ProductCardComponentWidgetState();
}

class _ProductCardComponentWidgetState
    extends State<ProductCardComponentWidget> {
  
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
        padding: EdgeInsetsDirectional.fromSTEB(5, 8, 5, 12),
        child: Container(
          width: 200,
          height: 200,
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
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 8, 2, 0),
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
                          style: TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 11,
                                
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
                                itemSize: 10,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: Text(
                                  '4.7',
                                  style: TextStyle(
                                        color: Color(0xFF14181B),
                                        fontSize: 10,
                                        
                                      ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFF14181B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: Text(
                            (widget.products['price'] ?? 0.0)
                                        .toStringAsFixed(0) +
                                    ' บาท ',
                            style:
                               TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
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
