import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  void _scanBarcode() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SimpleBarcodeScannerPage()),
    );

    if (result is String && result.isNotEmpty) {
      setState(() {
        _barcodeController.text = result;
      });
    }
  }

  void _addProduct() async {
    String name = _nameController.text.trim();
    String priceText = _priceController.text.trim();
    String barcode = _barcodeController.text.trim();

    if (name.isEmpty || priceText.isEmpty || barcode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    double price = double.tryParse(priceText) ?? 0.0;
    if (price <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter a valid price")));
      return;
    }

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'barcode': barcode,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Product Added Successfully")));

    _nameController.clear();
    _priceController.clear();
    _barcodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: "Product Price"),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeController,
                    decoration: InputDecoration(labelText: "Barcode Number"),
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: _scanBarcode,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addProduct, child: Text("Add Product")),
          ],
        ),
      ),
    );
  }
}
