import 'package:flutter/material.dart';
import 'add_product_sreen.dart';
import 'cart_screen.dart';
import 'scan_product_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
  }

  double getTotal() {
    return cart.fold(0, (sum, item) => sum + (item['price'] as num));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddProductScreen()),
                  ),
              child: Text("Add Product"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScanProductScreen(addToCart: addToCart),
                    ),
                  ),
              child: Text("Scan Product"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(cart: cart, total: getTotal()),
                    ),
                  ),
              child: Text("View Cart (${cart.length})"),
            ),
          ],
        ),
      ),
    );
  }
}
