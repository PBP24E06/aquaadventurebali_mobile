import 'package:aquaadventurebali_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:aquaadventurebali_mobile/screens/transaction_history.dart';
import 'package:aquaadventurebali_mobile/screens/user_profile/user_profile.dart';
import 'package:aquaadventurebali_mobile/screens/whislist.dart';
import 'package:aquaadventurebali_mobile/screens/list_product.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    // Body screens to display for each tab
    final List<Widget> body = [
      ProductPage(),
      Whislist(),
      CheckoutFormPage(productId: "47fe41cc-d4bb-43cd-802c-c7383014a6a9"),
      TransactionHistoryPage(),
      UserProfileWidget(),
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
            if (index > 2 && !request.loggedIn) {
              // Redirect to Login if not logged in
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            } else {
              // Update screen index if conditions are met
              _screenIndex = index;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
            icon: Icon(Icons.history_outlined),
            label: 'Transaksi',
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
