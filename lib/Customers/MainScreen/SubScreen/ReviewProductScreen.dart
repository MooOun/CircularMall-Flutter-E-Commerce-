// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewProductPageWidget extends StatefulWidget {
  const ReviewProductPageWidget({Key? key, required this.productId})
      : super(key: key);

  final String productId;

  @override
  _ReviewProductPageWidgetState createState() =>
      _ReviewProductPageWidgetState();
}

class _ReviewProductPageWidgetState extends State<ReviewProductPageWidget> {
  late Stream<QuerySnapshot> reviewsStream;

  @override
  void initState() {
    super.initState();
    reviewsStream = FirebaseFirestore.instance
        .collection('Products') // Adjust the collection name
        .doc(widget.productId)
        .collection('reviews') // Adjust the subcollection name
        .snapshots();
  }

  Future<double> calculateAverageRating() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productId)
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
      backgroundColor: Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'รีวิว',
          style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 26,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x39000000),
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 16, 12, 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: StreamBuilder(
                              stream: reviewsStream,
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                int numberOfReviews =
                                    snapshot.data?.docs.length ?? 0;

                                return Text(
                                  numberOfReviews.toString(),
                                  style: TextStyle(
                                        color: Color(0xFF14181B),
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                      ),
                                );
                              },
                            ),
                          ),
                          Text(
                            'จำนวนคนรีวิว',
                            style:TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                child: FutureBuilder<double>(
                                  future:
                                      calculateAverageRating(), // Add this method
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    double averageRating = snapshot.data ?? 0.0;

                                    return Text(
                                      averageRating.toStringAsFixed(
                                          1), // Show one decimal place
                                      style: TextStyle(
                                            color: Color(0xFF14181B),
                                            fontSize: 32,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 5),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF3A743),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'คะเนนรีวิวเฉลี่ย',
                            style:TextStyle(
                                  color: Color(0xFF57636C),
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: reviewsStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  }

                  print(
                      'Number of reviews: ${snapshot.data?.docs.length ?? 0}');

                  return ListView.builder(
  padding: EdgeInsets.zero,
  shrinkWrap: true,
  itemCount: snapshot.data?.docs.length ?? 0,
  itemBuilder: (context, index) {
    var reviewData = snapshot.data?.docs[index].data() as Map<String, dynamic>?;

    if (reviewData != null) {
      var comment = reviewData['comment'] ?? '';
      var email = reviewData['email'] ?? '';
      var name = reviewData['name'] ?? '';
      var rate = reviewData['rate'] ?? 0.0;
      var imageUrl = reviewData['imageUrl'] ?? ''; // Check for the existence of 'imageUrl'

      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 12, 5, 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.96,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF14181B),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                              child: RatingBarIndicator(
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFF3A743),
                                ),
                                direction: Axis.horizontal,
                                rating: rate.toDouble(),
                                unratedColor: Color(0xFF95A1AC),
                                itemCount: 5,
                                itemSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Check if imageUrl is not empty before trying to display the image
                  if (imageUrl.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                      child: Image.network(
                        imageUrl,
                        height: 100, // Adjust the height as needed
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            comment,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
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
      );
    } else {
      return SizedBox.shrink(); // Return an empty SizedBox if reviewData is null
    }
  },
);


                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
