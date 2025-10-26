import 'package:flutter/material.dart';
import '../models/laundry_category.dart';
import '../models/laundry_service.dart';

final List<LaundryCategory> dummyCategories = [
  LaundryCategory(
    name: 'Express',
    icon: Icons.flash_on,
    color: Color(0xFFFFE5E5),
  ),
  LaundryCategory(
    name: 'Reguler',
    icon: Icons.local_laundry_service,
    color: Color(0xFFFFE5CC),
  ),
  LaundryCategory(name: 'Premium', icon: Icons.star, color: Color(0xFFFFE5F0)),
  LaundryCategory(
    name: 'Sepatu',
    icon: Icons.sports_soccer,
    color: Color(0xFFE5F5FF),
  ),
  LaundryCategory(name: 'Setrika', icon: Icons.iron, color: Color(0xFFF0E5FF)),
];

final List<LaundryService> dummyBestSellers = [
  LaundryService(
    name: 'Cuci + Setrika',
    subtitle: '2-3 Hari',
    price: 'Rp 5.000/kg',
    discount: '20%',
    image: Icons.local_laundry_service,
    color: Color(0xFF4A90E2),
  ),
  LaundryService(
    name: 'Express 1 Hari',
    subtitle: 'Selesai 24 Jam',
    price: 'Rp 12.000/kg',
    discount: '15%',
    image: Icons.rocket_launch,
    color: Color(0xFFFF6B6B),
  ),
  LaundryService(
    name: 'Cuci Karpet',
    subtitle: 'Bersih Maksimal',
    price: 'Rp 25.000/m²',
    discount: '10%',
    image: Icons.grid_4x4,
    color: Color(0xFF50C878),
  ),
  LaundryService(
    name: 'Dry Cleaning',
    subtitle: 'Pakaian Premium',
    price: 'Rp 30.000/pcs',
    discount: '25%',
    image: Icons.checkroom,
    color: Color(0xFF9B59B6),
  ),
];

final List<LaundryService> dummyRecommended = [
  LaundryService(
    name: 'Cuci Sepatu',
    subtitle: 'Seperti Baru',
    price: 'Rp 18.000/pasang',
    discount: null,
    image: Icons.sports_soccer,
    color: Color(0xFF3498DB),
  ),
  LaundryService(
    name: 'Cuci Mobil',
    subtitle: 'Aman & Wangi',
    price: 'Rp 25.000/pcs',
    discount: null,
    image: Icons.toys,
    color: Color(0xFFE91E63),
  ),
];
