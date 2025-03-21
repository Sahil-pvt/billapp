import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final double total;

  const CartScreen({required this.cart, required this.total, Key? key})
    : super(key: key);

  void shareOnWhatsApp() async {
    String message = "🛒 *Order Summary:*\n";
    for (var item in cart) {
      message += "📌 ${item['name']} - ₹${item['price']}\n";
    }
    message += "\n💰 *Total: ₹${total.toStringAsFixed(2)}*";

    String encodedMessage = Uri.encodeComponent(message);
    String url = "https://wa.me/?text=$encodedMessage"; // Open WhatsApp

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print("Could not open WhatsApp.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text("Price: ₹${item['price']}"),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total: ₹${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: shareOnWhatsApp,
              icon: Icon(Icons.share, color: Colors.white),
              label: Text("Share on WhatsApp"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
