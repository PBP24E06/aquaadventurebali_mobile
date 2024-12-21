import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/screens/list_product.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
//import 'package:aquaadventurebali_mobile/screens/productentry_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Aqua Adventure Bali',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Find Your ...",
                  
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Halaman Utama'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.add_reaction_rounded),
              title: const Text('Daftar Produk'),
              onTap: () {
                  // Route menu ke halaman produk
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductPage()),
                  );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.add_shopping_cart),
            //   title: const Text('Tes checkout form'),
            //   // Bagian redirection ke MyHomePage
            //   onTap: () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const CheckoutFormPage(),
            //         ));
            //   },
            // ),
        ],
      ),
    );
  }
}