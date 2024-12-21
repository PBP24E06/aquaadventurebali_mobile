import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class CheckoutFormPage extends StatefulWidget {
  final String productId;

  const CheckoutFormPage({super.key, required this.productId});

  @override
  State<CheckoutFormPage> createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage>{
  final _formKey = GlobalKey<FormState>();
  String _fullName = "";
  String _email = "";
  String _phoneNumber = "";

  Future<Product> fetchProduct(CookieRequest request, String productId) async {
    
    
    final response = await request.get('http://127.0.0.1:8000/json-product/$productId');

    var data = response;
    
    // Melakukan konversi data json menjadi object MoodEntry
    List<Product> listProduct= [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct[0];
  }
    


  @override
  Widget build(BuildContext context){
    final request = context.watch<CookieRequest>();

    return FutureBuilder<Product>(
      future: fetchProduct(request, widget.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final product = snapshot.data!;
        // print("field gambar: " + product.fields.gambar);
        print("URL Gambar: http://127.0.0.1:8000/${product.fields.gambar.replaceFirst("/static/image", "")}");
        

        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Form Checkout',
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          // TODO: Tambahkan drawer yang sudah dibuat di sini
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Image.network(
                  //     "http://127.0.0.1:8000/${product.fields.gambar}",
                  //     width: 100,
                  //     height: 100,
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return const Text("Gagal memuat gambar");
                  //     },
                  //     loadingBuilder: (context, child, loadingProgress) {
                  //       if (loadingProgress == null) return child;
                  //       return const Center(child: CircularProgressIndicator());
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Nama Produk: ${product.fields.name}",
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Masukkan nama lengkap anda",
                          labelText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          
                          _fullName = value!;
                          
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Nama Pemesan tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Masukkan email anda",
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          
                          _email = value!;
                          
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Email tidak boleh kosong!";
                          }
                          if(!value.contains('@')){
                            return "Email tidak valid!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Masukkan nomor telepon anda",
                          labelText: "Nomor Telepon",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          
                          _phoneNumber = value!;
                          
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor telepon tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                              // Kirim ke Django dan tunggu respons
                              final response = await request.postJson(
                                  "http://127.0.0.1:8000/checkout-flutter/${widget.productId}",
                                  jsonEncode(<String, String>{
                                      'name': _fullName,
                                      'email': _email,
                                      'phone_number': _phoneNumber, 
                                  }),
                              );
                              print("Response status: ${response['status']}");
                              if (context.mounted) {
                                  if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                      content: Text("Checkout berhasil !"),
                                      ));
                                      Navigator.pop(context);
                                  } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content:
                                              Text("Terdapat kesalahan, silakan coba lagi."),
                                      ));
                                  }
                              }
                          }
                      },
                        child: const Text(
                          "Checkout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],)
            ),
          ),
        );
      },
    );
  }
}