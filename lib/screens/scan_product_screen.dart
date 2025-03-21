import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanProductScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) addToCart;
  const ScanProductScreen({Key? key, required this.addToCart})
    : super(key: key);

  @override
  _ScanProductScreenState createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  void _scanBarcode() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SimpleBarcodeScannerPage()),
    );

    if (result is String && result.isNotEmpty) {
      _fetchProduct(result);
    }
  }

  void _fetchProduct(String barcode) async {
    QuerySnapshot query =
        await FirebaseFirestore.instance
            .collection('products')
            .where('barcode', isEqualTo: barcode)
            .get();

    if (query.docs.isNotEmpty) {
      Map<String, dynamic> productData =
          query.docs.first.data() as Map<String, dynamic>;
      widget.addToCart(productData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added to Cart: ${productData['name']}")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Not Found!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Product")),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanBarcode,
          child: Text("Scan Product"),
        ),
      ),
    );
  }
}
