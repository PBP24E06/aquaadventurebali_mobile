import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProductEntryFormPage extends StatefulWidget {
  @override
  _ProductEntryFormPageState createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final storeController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && _image != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://[URL_APP_KAMU]/create-flutter/'),
      );
      request.fields['name'] = nameController.text;
      request.fields['kategori'] = categoryController.text;
      request.fields['harga'] = priceController.text;
      request.fields['toko'] = storeController.text;
      request.fields['alamat'] = addressController.text;
      request.fields['kontak'] = contactController.text;

      request.files.add(
        await http.MultipartFile.fromPath('gambar', _image!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil ditambahkan!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menambahkan produk.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua data harus diisi!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (value) =>
                    value!.isEmpty ? 'Kategori tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) =>
                    value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: storeController,
                decoration: const InputDecoration(labelText: 'Toko'),
                validator: (value) =>
                    value!.isEmpty ? 'Toko tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) =>
                    value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Kontak'),
                validator: (value) =>
                    value!.isEmpty ? 'Kontak tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _image == null
                  ? const Text('Tidak ada gambar dipilih.')
                  : Image.file(_image!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadData,
                child: const Text('Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
