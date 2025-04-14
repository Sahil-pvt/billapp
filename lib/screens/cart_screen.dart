import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double total;

  const CartScreen({required this.cart, required this.total, Key? key})
    : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cart;
  late double total;

  @override
  void initState() {
    super.initState();
    cart = List.from(widget.cart); // Create a local mutable copy of cart
    total = widget.total;
  }

  void removeFromCart(int index) {
    setState(() {
      total -= cart[index]['price'] as num;
      cart.removeAt(index);
    });
  }

  Future<void> shareOnWhatsApp() async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cart is empty! Add products before sharing.")),
      );
      return;
    }

    double totalAmount = total;
    String gpayLink =
        "upi://pay?pa=bhaveshromina2004@okaxis&cu=INR&am=$totalAmount";

    // First message: Order summary without link
    String message1 = """
🛒 *Order Summary:*
${cart.map((item) => "📌 ${item['name']} - ₹${item['price']}").join("\n")}

💰 *Total: ₹${totalAmount.toStringAsFixed(2)}*

✅ Tap the link below to pay via Google Pay.
""";

    // Second message: only GPay link (will appear as preview below)
    String encodedMessage1 = Uri.encodeComponent(message1);
    String encodedMessage2 = Uri.encodeComponent(gpayLink);

    // Combine the two messages
    String url = "https://wa.me/?text=$encodedMessage1%0A$encodedMessage2";

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not launch WhatsApp.")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open WhatsApp.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body:
          cart.isEmpty
              ? Center(child: Text("Your cart is empty!"))
              : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Colors.blueAccent,
                    ),
                    title: Text(item['name']),
                    subtitle: Text("Price: ₹${item['price']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFromCart(index),
                    ),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
