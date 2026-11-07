import 'package:flutter/material.dart';
import 'package:mini_katalog/services/api_service.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/components/product_card.dart';
import 'package:mini_katalog/views/cart_screen.dart';
import 'package:mini_katalog/views/product_detail_screen.dart';
import 'package:mini_katalog/services/local_storage_service.dart';
import 'package:mini_katalog/views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  List<Data> allproducts = [];
  bool isLoading = false;
  String errorMessage = '';
  Set<int> cardIds = {};
  String searchQuery = '';
  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      final productModel = await apiService.fetchProducts();
      if (!mounted) return;

      setState(() {
        allproducts = productModel.data ?? [];
      });
    } catch (e) {
      setState(() {
        debugPrint('Ürünler yüklenemedi: $e');
        if (!mounted) return;

        setState(() {
          errorMessage = 'Ürünler yüklenemedi. İnternet bağlantınızı kontrol edip tekrar deneyin.';
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await LocalStorageService().clearData();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final filteredProducts = allproducts.where((product) {
      return (product.name ?? '').toLowerCase().contains(query) ||
          (product.tagline ?? '').toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Cart",
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                allProducts: allproducts,
                                cardIds: cardIds,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: "Logout",
                        icon: Icon(Icons.logout),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Find your perfect devices",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search products",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://static.vecteezy.com/system/resources/thumbnails/041/928/868/small_2x/gifts-horizontal-web-banner-colorful-cardboard-boxes-with-bows-for-presents-for-birthdays-christmas-and-other-holidays-illustration-for-header-website-cover-templates-in-modern-design-vector.jpg",
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(errorMessage, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: loadProducts,
                              child: const Text('Tekrar dene'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    findProduct: product,
                                    cardIds: cardIds,
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
