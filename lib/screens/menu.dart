import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:aquaadventurebali_mobile/screens/transaction_history.dart';
import 'package:aquaadventurebali_mobile/screens/forum/discussions_screen.dart';
import 'package:aquaadventurebali_mobile/screens/user_profile/user_profile.dart';
import 'package:aquaadventurebali_mobile/screens/whislist.dart';
import 'package:aquaadventurebali_mobile/screens/list_product.dart';

class MyHomePage extends StatefulWidget {
  final String uname;
  final int userId;

  const MyHomePage({this.uname = "Guest", this.userId = 0, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Body screens to display for each tab
    final List<Widget> body = [
      ProductPage(),
      TransactionHistoryPage(),
      Whislist(),
      CheckoutFormPage(productId: "47fe41cc-d4bb-43cd-802c-c7383014a6a9"),
      UserProfileWidget(uname: widget.uname, userId: widget.userId),
      DiscussionScreens(widget.uname, widget.userId, productId: "47fe41cc-d4bb-43cd-802c-c7383014a6a9"),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _screenIndex,
        children: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F2937),
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
            label: 'Whislist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout),
            label: 'Checkout',
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
