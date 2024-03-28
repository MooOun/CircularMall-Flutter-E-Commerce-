import 'package:circularmallbc/Providers/Product_Provider.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    String name,
    double price,
    int quantity,
    List imagesUrl,
    String documentId,
    {String? size}// Use the correct parameter name here
  ) async {
    final products = Product(
      name: name,
      price: price,
      quantity: quantity,
      selectedSize: size, // Update to use the correct parameter
      imagesUrl: imagesUrl,
      documentId: documentId,
    );

    _list.add(products);

    notifyListeners();
  }

   void setItems(List<Product> items) {
    _list.clear();
    _list.addAll(items);
    notifyListeners();
  }



  void increament(Product product) {
    product.increaseCart();
    notifyListeners();
  }

  void decreament(Product product) {
    product.decreaseCart();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();

    notifyListeners();
  }
}
