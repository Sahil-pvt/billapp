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
  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot query =
        await FirebaseFirestore.instance
            .collection('products')
            .where('barcode', isEqualTo: barcode)
            .get();

    setState(() {
      _isLoading = false;
    });

    if (query.docs.isNotEmpty) {
      Map<String, dynamic> productData =
          query.docs.first.data() as Map<String, dynamic>;
      widget.addToCart(productData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Added to Cart: ${productData['name']}"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Product Not Found!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Product"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child:
            _isLoading
                ? CircularProgressIndicator() // Show a loading indicator when fetching data
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 120,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _scanBarcode,
                      icon: Icon(Icons.camera_alt, size: 24),
                      label: Text(
                        "Scan Product",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
