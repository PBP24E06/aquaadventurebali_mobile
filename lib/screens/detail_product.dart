import 'package:aquaadventurebali_mobile/screens/all_review.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // URL gambar
    String imageUrl = "assets/${product.fields.gambar}";

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

            // Kategori Produk
            Text(
              "Kategori:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.kategori,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Informasi Toko
            Text(
              "Toko:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.toko,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Alamat Toko
            Text(
              "Alamat:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.alamat,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Kontak Toko
            Text(
              "Kontak:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product.fields.kontak,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Ulasan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

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
