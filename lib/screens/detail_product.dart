import 'package:aquaadventurebali_mobile/models/review.dart';
import 'package:aquaadventurebali_mobile/screens/all_review.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});
  
  Future<List<Review>> fetchReviews(CookieRequest request) async {
    final response = await request.get(
      'http://127.0.0.1:8000/show-json-review/${product.pk}'
    );
    
    List<Review> listReview = [];
    for (var d in response) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }


  @override
  Widget build(BuildContext context) {
    // URL gambar
    String imageUrl = "assets/${product.fields.gambar}";
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Gambar tidak tersedia')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Nama Produk
            Text(
              product.fields.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Harga Produk
            Text(
              "Rp ${product.fields.harga}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),

            // Ulasan
            FutureBuilder<List<Review>>(
              future: fetchReviews(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                if (snapshot.hasData) {
                  double avgRating = 0;
                  if (snapshot.data!.isNotEmpty) {
                    avgRating = snapshot.data!.fold(0.0, (sum, review) => sum + review.fields.rating) / snapshot.data!.length;
                  }

                  
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllReviewPage(
                            productId: product.pk,
                            productName: product.fields.name,
                            productImage: product.fields.gambar,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${snapshot.data!.length} ratings)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),

            // Kategori Produk
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                product.fields.kategori,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Toko
            Row(
              children: [
                Icon(Icons.store),
                const SizedBox(width: 4),
                Text(
                  product.fields.toko,
                  style: const TextStyle(fontSize: 12),
                ),  
              ],
            ),
            const SizedBox(height: 16),

            // Alamat Toko
            Row(
              children: [
                Icon(Icons.location_on),
                const SizedBox(width: 4),
                Text(
                  product.fields.alamat,
                  style: const TextStyle(fontSize: 12),
                ),  
              ],
            ),
            const SizedBox(height: 16),

            // Kontak Toko
            Row(
              children: [
                Icon(Icons.call),
                const SizedBox(width: 4),
                Text(
                  product.fields.kontak,
                  style: const TextStyle(fontSize: 12),
                ),  
              ],
            ),
            const SizedBox(height: 32),

            // Tombol Beli
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CheckoutFormPage(productId: product.pk)
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Beli Sekarang",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Wishlist
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // Placeholder tanpa aksi
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Tambah ke Wishlist",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
