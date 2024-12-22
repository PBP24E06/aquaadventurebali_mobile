import 'package:aquaadventurebali_mobile/screens/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Future<List<Product>> fetchWishlist(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/get-user-wishlist/');
      List<Product> listProduct = [];
      for (var d in response) {
        if (d != null) {
          listProduct.add(Product.fromJson(d));
        }
      }
      return listProduct;
    } catch (e) {
      return [];
    }
  }

  Future<void> removeFromWishlist(CookieRequest request, String productId, BuildContext context) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/remove-user-wishlist/$productId/',
        {},
      );

      if (context.mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully removed from wishlist!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {});
        } else {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove from wishlist'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occurred while removing from wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchWishlist(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items in wishlist',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var product = snapshot.data![index];
              String imageUrl = "assets/${product.fields.gambar}";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      // Product Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.fields.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${product.fields.harga.toString()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.fields.kategori,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Remove Button
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => removeFromWishlist(request, product.pk, context),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}