import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:aquaadventurebali_mobile/screens/productentry_form.dart';
import 'package:http/http.dart' as http;
import 'package:aquaadventurebali_mobile/screens/detail_product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json-product/');
    var data = response;

    List<Product> productList = [];
    for (var d in data) {
      if (d != null) {
        productList.add(Product.fromJson(d));
      }
    }
    return productList;
  }

Future<void> _deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/delete-flutter/$id/'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductPage()),
      ); // Refresh data produk
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus produk!')),
      );
    }
  }

Future<bool> isAdmin(CookieRequest request) async {
  final response = await request.get('http://127.0.0.1:8000/user-status/');
  return response['is_admin'];
}

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqua Adventure Bali'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tambahkan tombol Add Product di atas sebelum card
          FutureBuilder(
            future: isAdmin(request), // Mengecek apakah admin
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman tambah produk
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductEntryFormPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add Product",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Jangan tampilkan apa-apa
              }
            },
          ),
          // Bagian untuk menampilkan daftar produk
          Expanded(
            child: FutureBuilder(
              future: fetchProducts(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'Belum ada data produk pada Aqua Adventure Bali.',
                        style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        final product = snapshot.data![index].fields;
                        final pk = snapshot.data![index].pk;
                        // String imageUrl = "http://127.0.0.1:8000/${product.gambar}";

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: const BorderRadius.vertical(
                              //       top: Radius.circular(12)),
                              //   child: Image.network(
                              //     imageUrl,
                                  
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp ${product.harga}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetailPage(product: snapshot.data![index].fields, pk: pk,),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text("Detail"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Aksi untuk membeli produk
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CheckoutFormPage(productId: snapshot.data![index].pk),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            backgroundColor: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text("Beli"),
                                        ),
                                        FutureBuilder(
                                          future: isAdmin(request),
                                          builder: (context, AsyncSnapshot<bool> snapshot) {
                                            if (snapshot.hasData && snapshot.data == true) {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  // Panggil fungsi untuk menghapus produk
                                                  _deleteProduct(pk);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: const Text("Delete"),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}