// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/SubScreen/OnboardScreen.dart';
import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadSlipPage extends StatefulWidget {
  final Map<String, dynamic> data;

  UploadSlipPage({required this.data});

  @override
  _UploadSlipPageState createState() => _UploadSlipPageState();
}

class _UploadSlipPageState extends State<UploadSlipPage> {
  File? _selectedImage;
  late String orderId;
  String imageUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference =
            storage.ref().child('slip_images/${Uuid().v4()}');
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);

        await uploadTask.whenComplete(() async {
          try {
            imageUrl = await storageReference.getDownloadURL();
          } catch (error) {
            print('Error getting download URL: $error');
          }
        });

        if (imageUrl.isNotEmpty) {
          List<dynamic> cartItemsCopy =
              List.from(context.read<Cart>().getItems);

          if (cartItemsCopy.isNotEmpty) {
            CollectionReference orderRef =
                FirebaseFirestore.instance.collection('Orders');
            CollectionReference productsRef =
                FirebaseFirestore.instance.collection('Products');

            orderId = Uuid().v4();
            QuerySnapshot<Map<String, dynamic>> addressesSnapshot =
                await FirebaseFirestore.instance
                    .collection('Customers')
                    .doc(_auth.currentUser!.uid)
                    .collection('addresses')
                    .where('addressStatus', isEqualTo: true)
                    .get();

            if (addressesSnapshot.docs.isNotEmpty) {
              Map<String, dynamic> selectedAddress =
                  addressesSnapshot.docs.first.data();

              double totalOrderPrice = 0.0;

              List<Map<String, dynamic>> ordersData = [];

              for (var item in cartItemsCopy) {
                double itemTotalPrice = item.quantity * item.price;
                totalOrderPrice += itemTotalPrice;

                await productsRef.doc(item.documentId).update({
                  'sizes.${item.selectedSize}.quantity':
                      FieldValue.increment(-item.quantity),
                  'soldCount': FieldValue.increment(item.quantity),
                });

                ordersData.add({
                  'productId': item.documentId,
                  'orderName': item.name,
                  'orderImage': item.imagesUrl.first,
                  'orderQuantity': item.quantity,
                  'orderPrice': itemTotalPrice,
                });
              }

              await orderRef.doc(orderId).set(
                {
                  'uid': _auth.currentUser!.uid,
                  'customerName': widget.data['customerName'],
                  'email': widget.data['email'],
                  'address': selectedAddress['address'],
                  'phone': selectedAddress['phone'],
                  'tumbon': selectedAddress['tumbon'],
                  'amphoe': selectedAddress['amphoe'],
                  'jangwhat': selectedAddress['jangwhat'],
                  'postCode': selectedAddress['postCode'],
                  'noteAddress': selectedAddress['noteAddress'],
                  'orders': ordersData,
                  'orderId': orderId,
                  'deliveryDate': '',
                  'paymentStatus': 'PromptPay',
                  'orderReview': false,
                  'deliveryService': '',
                  'totalOrderPrice': totalOrderPrice,
                  'trackingNumber': '',
                  'orderDate': DateTime.now(),
                  'deliverStatus': 'notconfirmed',
                  'notconfirmed': true,
                  'onconfirmed': false,
                  'confirmDate': '',
                  'prepareTranspot': false,
                  'prepareDate': '',
                  'transpot': false,
                  'transpotDate': '',
                  'delivered': false,
                  'slipImg': imageUrl,
                  'shippingStatus': '',
                  'inshipping': false,
                  'inshippingDate': '',
                  'Sorting': false,
                  'SortingDate': '',
                  'shipping': false,
                  'shippingDate': '',
                },
              );
              context.read<Cart>().clearCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OnboardScreenPageWidget()),
              );
              print('Cleared');
            }
            ;
          }

          Navigator.pop(context);
        } else {
          print('Image upload failed');
        }
      } catch (error) {
        print('Error uploading image: $error');
      } finally {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OnboardScreenPageWidget()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'อัพโหลดสลิปโอนเงิน',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'อัพโหลดสลิปการชำระเงิน',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 300, width: 300)
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('เลือกรูปภาพ'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedImage != null ? _uploadImage : null,
                child: Text('อัพโหลดสลิปโอนเงิน'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
