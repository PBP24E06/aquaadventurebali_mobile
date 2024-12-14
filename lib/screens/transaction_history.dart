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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Id Produk: ${snapshot.data![index].fields.product}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Nama Pemesan: ${snapshot.data![index].fields.name}"),
                      const SizedBox(height: 10),
                      Text("Email: ${snapshot.data![index].fields.email}"),
                      const SizedBox(height: 10),
                      Text("Nomor Telepon: ${snapshot.data![index].fields.phoneNumber}"),
                      const SizedBox(height: 10),
                      Text("Waktu Checkout: ${snapshot.data![index].fields.checkoutTime}"), 
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
  
}