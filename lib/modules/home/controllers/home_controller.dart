import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../models/home_model.dart';

final homeControllerProvider = Provider<HomeController>((ref) {
  return HomeController();
});

class HomeController {
  final List<HomeCategory> categories = const [
    HomeCategory(
      name: 'Mesin',
      icon: Icons.settings_suggest_outlined,
      color: Color(0xFFE8F4EE),
    ),
    HomeCategory(
      name: 'Rem',
      icon: Icons.tire_repair_outlined,
      color: Color(0xFFFFECE8),
    ),
    HomeCategory(
      name: 'Oli',
      icon: Icons.opacity_outlined,
      color: Color(0xFFFFF3D9),
    ),
    HomeCategory(
      name: 'Aki',
      icon: Icons.battery_charging_full_outlined,
      color: Color(0xFFE7F0FF),
    ),
    HomeCategory(
      name: 'Ban',
      icon: Icons.directions_car_filled_outlined,
      color: Color(0xFFF0EAFE),
    ),
    HomeCategory(
      name: 'Lampu',
      icon: Icons.light_mode_outlined,
      color: Color(0xFFFFF0CC),
    ),
  ];

  final List<HomePromotion> promotions = const [
    HomePromotion(
      title: 'Gratis Ongkir',
      subtitle: 'Untuk pembelian minimal Rp500.000',
      buttonLabel: 'Belanja Sekarang',
      startColor: AppColors.primary,
      endColor: AppColors.accent,
    ),
  ];

  final List<HomeProduct> popularProducts = const [
    HomeProduct(
      name: 'Filter Oli Atrans',
      brand: 'Denso',
      category: 'Filter & Oli',
      price: 85000,
      oldPrice: 105000,
      rating: 4.8,
      sold: 124,
      imageUrl: 'http://atransparts.com/uploads/products/17557670391.jpg',
    ),
    HomeProduct(
      name: 'Filter Udara Atrans',
      brand: 'BRT',
      category: 'Sistem Udara',
      price: 185000,
      rating: 4.9,
      sold: 89,
      imageUrl: 'https://atransparts.com/uploads/products/17557686581.jpg',
    ),
    HomeProduct(
      name: 'Kampas Rem',
      brand: 'Brembo',
      category: 'Rem',
      price: 420000,
      oldPrice: 465000,
      rating: 4.7,
      sold: 56,
      imageUrl: 'https://atransparts.com/uploads/products/17557673651.jpg',
    ),
    HomeProduct(
      name: 'Oli Shell Helix Ultra 5W-40',
      brand: 'Castrol',
      category: 'Oli Mesin',
      price: 310000,
      rating: 4.8,
      sold: 203,
      imageUrl: 'https://atransparts.com/uploads/products/17557682341.jpg',
    ),
  ];

  final List<HomeProduct> recommendedProducts = const [
    HomeProduct(
      name: 'Kampas Kopling Atrans',
      brand: 'NGK',
      category: 'Pengapian',
      price: 165000,
      rating: 4.9,
      sold: 176,
      imageUrl: 'https://atransparts.com/uploads/products/17557676911.jpg',
    ),
    HomeProduct(
      name: 'Filter AC',
      brand: 'Yuasa',
      category: 'Kelistrikan',
      price: 920000,
      oldPrice: 980000,
      rating: 4.6,
      sold: 72,
      imageUrl: 'https://atransparts.com/uploads/products/17557671851.jpg',
    ),
  ];
}
