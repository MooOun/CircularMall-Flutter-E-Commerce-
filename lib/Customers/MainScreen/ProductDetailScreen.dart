// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:circularmallbc/Components/ImageProductDetail.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/ReviewProductScreen.dart';
import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:circularmallbc/Providers/wishlist_provider.dart';
import 'package:circularmallbc/Utils/Snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductDetailScreenWidget extends StatefulWidget {
  const ProductDetailScreenWidget({super.key, this.productList});
  final dynamic productList;

  @override
  State<ProductDetailScreenWidget> createState() =>
      _ProductDetailScreenWidgetState();
}

class ImageGallery extends StatelessWidget {
  final Map<String, String> imageUrls;

  const ImageGallery({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls.values.toList()[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 395,
                height: 350,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductDetailScreenWidgetState extends State<ProductDetailScreenWidget>
    with TickerProviderStateMixin {
  late List<dynamic> imageList = widget.productList['imgProduct'];
  String? selectedSize;
  late Stream<QuerySnapshot> reviewsStream;
  late Map<String, Map<String, dynamic>> availableSizesMap = {};

  @override
  void initState() {
    super.initState();
    debugPrint('Init State: Selected Size: $selectedSize');
    reviewsStream = FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productList['productId'])
        .collection('reviews')
        .snapshots();

    fetchProductSizesMap(widget.productList['productId']).then((sizesMap) {
      setState(() {
        availableSizesMap = sizesMap;
      });
    });
    print('Init State: Selected Size: $selectedSize');
  }

  Future<Map<String, Map<String, dynamic>>> fetchProductSizesMap(
      String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        dynamic sizesData = productSnapshot['sizes'];

        if (sizesData is Map<String, dynamic>) {
          // If 'sizes' is a map, return the map
          return Map<String, Map<String, dynamic>>.from(sizesData);
        }
      }
    } catch (e) {
      print('Error fetching product sizes: $e');
    }
    return {};
  }

  Widget buildSizeChips() {
  List<String> orderedSizes = ['S', 'M', 'L', 'XL', 'XXL'];

  return Wrap(
    spacing: 12.0,
    runSpacing: 24.0,
    children: orderedSizes
        .where((size) =>
            availableSizesMap?[size] != null &&
            availableSizesMap![size]!['hasQuantity'] == true)
        .map((size) {
      bool isSelected = size == selectedSize;

      return ChoiceChip(
        label: Text(size),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedSize = selected ? size : null;
          });
          print('Selected Size: $selectedSize');
        },
        backgroundColor: isSelected ? Color(0xFF4B39EF) : Color(0xFFE0E3E7),
        selectedColor: Color(0xFF4B39EF),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF57636C),
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        elevation: isSelected ? 2 : 0,
      );
    }).toList(),
  );
}



  Future<double> calculateAverageRatingForProduct() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productList['productId'])
        .collection('reviews')
        .get();

    if (snapshot.docs.isEmpty) {
      return 0.0; // Default to 0 if there are no reviews
    }

    double totalRating = 0.0;
    int numberOfReviews = snapshot.docs.length;

    snapshot.docs.forEach((review) {
      totalRating += (review['rate'] ?? 0.0);
    });

    return totalRating / numberOfReviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFFDBE2E7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return FullImageScreen(
                                              imagesList: imageList);
                                        }));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Image.network(
                                            imageList[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 32, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: Color(0x3A000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            buttonSize: 46,
                                            icon: Icon(
                                              Icons.arrow_back_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);

                                            },
                                          ),
                                        ),
                                        Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: Color(0x3A000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  final wishList = context
                                                      .read<WishList>()
                                                      .getWishItem;
                                                  final product =
                                                      wishList.firstWhereOrNull(
                                                    (product) =>
                                                        product.documentId ==
                                                        widget.productList[
                                                            'productId'],
                                                  );

                                                  if (product != null) {
                                                    context
                                                        .read<WishList>()
                                                        .removeThis(
                                                            widget.productList[
                                                                'productId']);
                                                  } else {
                                                    context
                                                        .read<WishList>()
                                                        .addWishItem(
                                                          widget.productList[
                                                              'productName'],
                                                          widget.productList[
                                                              'price'],
                                                          1,
                                                          widget.productList[
                                                              'imgProduct'],
                                                          widget.productList[
                                                              'productId'],
                                                          selectedSize!,
                                                        );
                                                  }
                                                },
                                                icon: Provider.of<WishList>(
                                                                context,
                                                                listen: true)
                                                            .getWishItem
                                                            .firstWhereOrNull((product) =>
                                                                product
                                                                    .documentId ==
                                                                widget.productList[
                                                                    'productId']) !=
                                                        null
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(Icons
                                                        .favorite_border_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 20, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productList['productName'],
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              ' ${widget.productList['price'].toStringAsFixed(0)} บาท',
                              style: TextStyle(
                                color: Color(0xFF4B39EF),
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'จำหน่ายโดย : CircularMall',
                              style: TextStyle(
                                color: Color(0xFF57636C),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                'ขายแล้ว ${widget.productList['soldCount']} ชิ้น',
                                style: TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FutureBuilder<double>(
                                  future: calculateAverageRatingForProduct(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    double averageRating = snapshot.data ?? 0.0;

                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        RatingBarIndicator(
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFFFFA130),
                                          ),
                                          direction: Axis.horizontal,
                                          rating: averageRating,
                                          unratedColor: Color(0xFF95A1AC),
                                          itemCount: 5,
                                          itemSize: 24,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 0, 0, 0),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewProductPageWidget(
                                                    productId:
                                                        widget.productList[
                                                            'productId'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '${averageRating.toStringAsFixed(0)}/5 รีวิว',
                                              style: TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            FFButtonWidget(
                              onPressed: selectedSize?.isNotEmpty == true
                                  ? () {
                                      final cart =
                                          context.read<Cart>().getItems;
                                      final product = cart.firstWhereOrNull(
                                        (product) =>
                                            product.documentId ==
                                            widget.productList['productId'],
                                      );

                                      if (product != null) {
                                        ShowSnackBar(
                                          context,
                                          'สินค้าชิ้นนี้อยู่ในตระกร้าของคุณแล้ว',
                                        );
                                      } else {
                                        context.read<Cart>().addItem(
                                              widget.productList['productName'],
                                              widget.productList['price'].toDouble(),
                                              1,
                                              widget.productList['imgProduct'],
                                              widget.productList['productId'],
                                              size: selectedSize!,
                                            );
                                      }
                                    }
                                  : null, // ปุ่มถูกปิดใช้งานหาก selectedSize เป็น null หรือว่างเปล่า
                              text: 'เพิ่มใส่ตะกร้า',
                              options: FFButtonOptions(
                                width: 100,
                                height: 42,
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: Color(0xFF4B39EF),
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'SIZE',
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 32),
                        child: buildSizeChips(),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'รายละเอียดสินค้า',
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                widget.productList['description'],
                                style: TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
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
            ),
          ],
        ),
      ),
    );
  }
}
