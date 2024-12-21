import 'package:aquaadventurebali_mobile/screens/checkout.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:aquaadventurebali_mobile/screens/product_page.dart';
import 'package:aquaadventurebali_mobile/screens/transaction_history.dart';
import 'package:aquaadventurebali_mobile/screens/user_profile.dart';
import 'package:aquaadventurebali_mobile/screens/whislist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:aquaadventurebali_mobile/screens/list_product.dart';


class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {
  int _screenIndex = 0;
  final List<Widget> body = [
    ProductPage(),
    TransactionHistoryPage(),
    Whislist(),
    UserProfile(),
  ];

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1F2937),
        currentIndex: _screenIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _screenIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Whistlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
