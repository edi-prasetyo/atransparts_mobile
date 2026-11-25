import 'package:flutter/material.dart';

class HomeCategory {
  final String name;
  final IconData icon;
  final Color color;

  const HomeCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class HomeProduct {
  final String name;
  final String brand;
  final String category;
  final int price;
  final int? oldPrice;
  final double rating;
  final int sold;
  final String imageUrl;

  const HomeProduct({
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.sold,
    required this.imageUrl,
  });
}

class HomePromotion {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color startColor;
  final Color endColor;

  const HomePromotion({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.startColor,
    required this.endColor,
  });
}
