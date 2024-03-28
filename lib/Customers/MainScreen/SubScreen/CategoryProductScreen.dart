import 'package:circularmallbc/Customers/MainScreen/ProductDetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryProductScreen extends StatelessWidget {
  final QueryDocumentSnapshot category;

  const CategoryProductScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Category Name: ${category['categoryName']}');

    return Scaffold(
      appBar: AppBar(
        title: Text(category['categoryName']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .where('category', isEqualTo: category['categoryName'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
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
                'ไม่พบสินค้าในหมวดหมู่นี้',
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

          print('Number of products: ${snapshot.data!.docs.length}');

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product = snapshot.data!.docs[index].data() as Map<String, dynamic>?;

              return GestureDetector(
                onTap: () {
                  if (product != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreenWidget(
                          productList: product,
                        ),
                      ),
                    );
                  }
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
                            product?['imgProduct'][0] ?? '',
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
                                    product?['productName'] ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF14181B),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 8, 0, 0),
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
                                          itemSize: 15,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4, 0, 0, 0),
                                          child: Text(
                                            '4.7 ดาว',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 7, 0),
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF14181B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 8, 0),
                                    child: Text(
                                      (product?['price'] ?? 0.0)
                                              .toStringAsFixed(0) +
                                          ' บาท ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
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
            },
          );
        },
      ),
    );
  }
}
