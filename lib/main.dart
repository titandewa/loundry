import 'package:flutter/material.dart';
import 'pages/product_catalog_page.dart';
import 'experiments/comparison_page.dart';

void main() {
  runApp(const LaundryApp());
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Laundry Dinamis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),

      
      home: const ProductCatalogPage(),


      routes: {
        '/home': (context) => const ProductCatalogPage(),
        '/experiment': (context) => const ComparisonPage(),
      },
    );
  }
}
