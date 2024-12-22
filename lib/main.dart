import 'package:aquaadventurebali_mobile/screens/checkout_form.dart';
import 'package:aquaadventurebali_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
  SemanticsBinding.instance.ensureSemantics();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Aqua Adventure Bali',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.blue[400]),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
