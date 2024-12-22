import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/models/transaction.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:aquaadventurebali_mobile/screens/login.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
import 'package:aquaadventurebali_mobile/screens/review_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class TransactionHistoryPage extends StatefulWidget{
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>{

  Future<List<Transaction>> fetchTransactionHistory(CookieRequest request) async {
    final response = await request.get('https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/get-user-transaction-id/');

    var data = response;
    
    // Melakukan konversi data json menjadi object MoodEntry
    List<Transaction> listTransaction= [];
    for (var d in data) {
      if (d != null) {
        listTransaction.add(Transaction.fromJson(d));
      }
    }
    return listTransaction;
  }

  Future<bool> hasUserReviewed(CookieRequest request, String productId) async {
    try {
      final response = await request.get(
        'https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/has-user-reviewed-json/$productId/',
      );

      return response['has_reviewed'] ?? false;
    } catch (e) {

      return false;
    }
  }

  Future<Product> fetchProduct(CookieRequest request, String productId) async{
    final response = await request.get('https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/json-product/$productId');

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
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (!request.loggedIn) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage())
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: fetchTransactionHistory(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Anda belum pernah melakukan checkout.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(8),
                  
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang box
                    borderRadius: BorderRadius.circular(12), // Sudut melengkung
                    border: Border.all(
                      color: Colors.grey, 
                      width: 1, 
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 7,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: fetchProduct(request, snapshot.data![index].fields.product), 
                        builder: (context, AsyncSnapshot productSnapshot){
                          if (productSnapshot.data == null) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          else{
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [ 
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(246, 223, 217, 217), 
                                          width: 4, 
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 219, 231, 225),
                                            offset: Offset(
                                              5.0,
                                              5.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                        child: Image(
                                          image: AssetImage('assets/${productSnapshot.data!.fields.gambar}'),
                                          width: 80,
                                          height: 80,
                                        )
                                      )
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Text(
                                              "${productSnapshot.data!.fields.name}",
                                              style: GoogleFonts.sourceSans3(
                                                textStyle: Theme.of(context).textTheme.displayLarge,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.visible,
                                              
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Text(
                                              "Rp ${productSnapshot.data!.fields.harga}",
                                              style: GoogleFonts.lato(
                                                textStyle: Theme.of(context).textTheme.displayLarge,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true, 
                                              overflow: TextOverflow.visible, 
                                            ),
                                          ),
                                        ],
                                      )
                                    )
                                  ]
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "Nama Pemesan: ${snapshot.data![index].fields.name}",
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "Email: ${snapshot.data![index].fields.email}",
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "Kontak Pemesan: ${snapshot.data![index].fields.phoneNumber}",
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "Waktu Checkout: ${snapshot.data![index].fields.checkoutTime}",
                                    style: GoogleFonts.sourceSans3(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FutureBuilder(
                                          future: hasUserReviewed(request, snapshot.data![index].fields.product),
                                          builder: (context, AsyncSnapshot<bool> reviewSnapshot) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  side: BorderSide(
                                                    color: (reviewSnapshot.data ?? false) ? Colors.grey : Colors.blue,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                elevation: 2,
                                                fixedSize: const Size(110, 35), 
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                              ),
                                              onPressed: (reviewSnapshot.data ?? false) ? null : () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ReviewFormPage(
                                                      productId: snapshot.data![index].fields.product,
                                                      productName: productSnapshot.data!.fields.name,
                                                      productImage: productSnapshot.data!.fields.gambar,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                (reviewSnapshot.data ?? false) ? "Already Reviewed!" : "Write Review",
                                                style: GoogleFonts.sourceSans3(
                                                  fontSize: 12.0,
                                                  color: (reviewSnapshot.data ?? false) ? Colors.grey : Colors.blue,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              side: const BorderSide(
                                                color: Colors.green,
                                                width: 1.0,
                                              ),
                                            ),
                                            elevation: 2,
                                            fixedSize: const Size(90, 35),
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CheckoutFormPage(
                                                  productId: snapshot.data![index].fields.product,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Beli Lagi",
                                            style: GoogleFonts.sourceSans3(
                                              fontSize: 12.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ), 
                              ]
                            );
                          }
                        }
                      )
                    ],
                  )
                ),
              );
            }
          }
        },
      ),
    );
  }
}