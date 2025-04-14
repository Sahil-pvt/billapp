import 'package:flutter/material.dart';
import 'add_product_sreen.dart';
import 'cart_screen.dart';
import 'scan_product_screen.dart';

class HomeScreen extends StatefulWidget {
  final TextEditingController titleController;
  final ValueChanged<String> onTitleChange;

  const HomeScreen({
    Key? key,
    required this.titleController,
    required this.onTitleChange,
  }) : super(key: key);

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
      appBar: AppBar(
        title: TextField(
          controller: widget.titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter title...",
            suffixIcon:
                widget.titleController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        widget.onTitleChange(""); // Update the title in MyApp
                      },
                    )
                    : null,
          ),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          onChanged: widget.onTitleChange, // Update in MyApp
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtonCard(
              icon: Icons.add_circle_outline,
              title: "Add Product",
              color: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddProductScreen()),
                  ),
            ),
            const SizedBox(height: 16),
            _buildButtonCard(
              icon: Icons.qr_code_scanner,
              title: "Scan Product",
              color: Colors.green,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScanProductScreen(addToCart: addToCart),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            _buildButtonCard(
              icon: Icons.shopping_cart_outlined,
              title: "View Cart (${cart.length})",
              color: Colors.orange,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(cart: cart, total: getTotal()),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a custom button card with an icon and text.
  Widget _buildButtonCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}
