import 'package:flutter/material.dart';

class LaundryService {
  final String name;
  final String subtitle;
  final String price;
  final String? discount;
  final IconData image;
  final Color color;

  LaundryService({
    required this.name,
    required this.subtitle,
    required this.price,
    this.discount,
    required this.image,
    required this.color,
  });
}
