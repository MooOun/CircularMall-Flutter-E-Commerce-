class Product {
  String name;
  double price;
  int quantity = 1;
  
  List imagesUrl;
  String documentId;
  String? selectedSize;


  Product({
    required this.name,
    required this.price,
    required this.quantity,
    this.selectedSize,
    required this.imagesUrl,
    required this.documentId,

  });

  set setSize(String? size) {
    selectedSize = size;
  }
  
  void increaseCart() {
    quantity++;
  }

  void decreaseCart() {
    quantity--;
  }
}
