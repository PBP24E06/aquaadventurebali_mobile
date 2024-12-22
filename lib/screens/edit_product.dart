import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aquaadventurebali_mobile/screens/list_product.dart';

class EditProductPage extends StatefulWidget {
  final Fields product;
  final String pk;

  const EditProductPage({super.key, required this.product, required this.pk});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hargaController;
  late TextEditingController _kategoriController;
  late TextEditingController _tokoController;
  late TextEditingController _alamatController;
  late TextEditingController _kontakController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _hargaController = TextEditingController(text: widget.product.harga.toString());
    _kategoriController = TextEditingController(text: widget.product.kategori);
    _tokoController = TextEditingController(text: widget.product.toko);
    _alamatController = TextEditingController(text: widget.product.alamat);
    _kontakController = TextEditingController(text: widget.product.kontak);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hargaController.dispose();
    _kategoriController.dispose();
    _tokoController.dispose();
    _alamatController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim permintaan PUT ke API Django
  Future<void> _updateProduct() async {
    final url = Uri.parse('https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/edit-product-flutter/${widget.pk}/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _nameController.text,
        'harga': int.parse(_hargaController.text),
        'kategori': _kategoriController.text,
        'toko': _tokoController.text,
        'alamat': _alamatController.text,
        'kontak': _kontakController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Jika berhasil, beri tahu pengguna dan kembali ke halaman sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductPage()),
      );
    } else {
      // Jika gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan perubahan')),
      );
    }
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      _updateProduct();  // Panggil fungsi untuk memperbarui produk
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hargaController,
                  decoration: const InputDecoration(labelText: 'Harga Produk'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _kategoriController,
                  decoration: const InputDecoration(labelText: 'Kategori Produk'),
                ),
                TextFormField(
                  controller: _tokoController,
                  decoration: const InputDecoration(labelText: 'Nama Toko'),
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat Toko'),
                ),
                TextFormField(
                  controller: _kontakController,
                  decoration: const InputDecoration(labelText: 'Kontak Toko'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
