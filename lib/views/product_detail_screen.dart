import 'package:flutter/material.dart';
import 'package:mini_katalog/models/products_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Data findProduct;
  final Set<int> cardIds;
  const ProductDetailScreen({
    super.key,
    required this.findProduct,
    required this.cardIds,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text("Back")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    widget.findProduct.image ?? "",
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.findProduct.name ?? 'Unnamed product',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.findProduct.tagline ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                SizedBox(height: 10),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  widget.findProduct.description ?? '',
                  style: TextStyle(height: 1.5, color: Colors.grey.shade800),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  widget.findProduct.price ?? 'N/A',
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final id = widget.findProduct.id;
                    if (id != null) {
                      setState(() {
                        widget.cardIds.add(id);
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                        margin: EdgeInsets.only(
                          bottom: 80,
                          left: 20,
                          right: 20,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
