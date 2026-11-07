import 'package:flutter/material.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/components/cart_item_tile.dart';
import 'package:mini_katalog/services/local_storage_service.dart';
import 'package:mini_katalog/views/login_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Data> allProducts;
  final Set<int> cardIds;
  const CartScreen({
    super.key,
    required this.allProducts,
    required this.cardIds,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _logout() async {
    await LocalStorageService().clearData();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = widget.allProducts
        .where((product) => widget.cardIds.contains(product.id))
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: cartProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Your cart is empty",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartProducts.length,
                        itemBuilder: ((context, index) {
                          final product = cartProducts[index];
                          return CartItemTile(
                            name: product.name ?? 'Unnamed product',
                            tagline: product.tagline ?? '',
                            imageUrl: product.image ?? '',
                            price: product.price ?? 'N/A',
                            onRemove: () {
                              setState(() {
                                widget.cardIds.remove(product.id);
                              });
                            },
                          );
                        }),
                      ),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                onPressed: cartProducts.isEmpty
                    ? null
                    : () {
                        setState(() {
                          widget.cardIds.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your order has been placed!'),
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
                style: ElevatedButton.styleFrom(),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
