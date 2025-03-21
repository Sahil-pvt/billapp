import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class FirebaseService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');
  final uuid = Uuid();

  Future<void> addProduct(String name, double price, String barcode) async {
    String id = uuid.v4();
    await productsCollection.doc(id).set({
      'id': id,
      'name': name,
      'price': price,
      'barcode': barcode,
    });
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    var snapshot =
        await productsCollection.where('barcode', isEqualTo: barcode).get();
    if (snapshot.docs.isNotEmpty) {
      return Product.fromMap(
        snapshot.docs.first.data() as Map<String, dynamic>,
      );
    }
    return null;
  }
}
