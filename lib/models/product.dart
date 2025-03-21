class Product {
  String id;
  String name;
  double price;
  String barcode;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'barcode': barcode};
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      barcode: map['barcode'],
    );
  }
}
