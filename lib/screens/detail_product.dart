import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/screens/edit_product.dart';

class ProductDetailPage extends StatelessWidget {
  final Fields product;
  final String pk;

  const ProductDetailPage({super.key, required this.product, required this.pk});

  @override
  Widget build(BuildContext context) {
    // URL gambar
    // String imageUrl = "http://127.0.0.1:8000/${product.gambar}";

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(12),
            //   child: Image.network(
            //     imageUrl,
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //     height: 300,
            //     // errorBuilder: (context, error, stackTrace) {
            //     //   return Container(
            //     //     width: double.infinity,
            //     //     height: 300,
            //     //     color: Colors.grey[300],
            //     //     child: const Center(child: Text('Gambar tidak tersedia')),
            //     //   );
            //     // },
            //   ),
            // ),
            // const SizedBox(height: 16),

            // Nama Produk
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Harga Produk
            Text(
              "Rp ${product.harga}",
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
              product.kategori,
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
              product.toko,
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
              product.alamat,
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
              product.kontak,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Tombol Beli
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk dibeli!')),
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
            // Tombol Edit Produk
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman EditProductPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(product: product, pk:pk),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Edit Produk",
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
