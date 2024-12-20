import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/models/transaction.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
import 'package:flutter/material.dart';
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
    final response = await request.get('http://127.0.0.1:8000/get-user-transaction-id/');

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

  Future<Product> fetchProduct(CookieRequest request, String productId) async{
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
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
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
                                      width: 100,
                                      height: 100,
                                    )
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Nama Pemesan: ${snapshot.data![index].fields.name}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Email: ${snapshot.data![index].fields.email}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Email: ${snapshot.data![index].fields.phoneNumber}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Email: ${snapshot.data![index].fields.checkoutTime}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
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