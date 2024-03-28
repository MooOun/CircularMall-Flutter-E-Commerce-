import 'package:circularmallbc/Providers/Product_Provider.dart';
import 'package:flutter/material.dart';

class WishList extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishItem {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int quantity,
    List imagesUrl,
    String documentId,
    String selectedSize,
  ) async {
    final products = Product(
      name: name,
      price: price,
      selectedSize : selectedSize,
      quantity: quantity,
      imagesUrl: imagesUrl,
      documentId: documentId,
    );

    _list.add(products);

    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();

    notifyListeners();
  }

  removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
