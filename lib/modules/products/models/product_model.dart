class ProductModel {
  final int id;
  final String name;
  final String brand;
  final String category;
  final int price;
  final int? oldPrice;
  final double rating;
  final int sold;
  final String imageUrl;
  final String? description;
  final List<String>? specifications;
  final String? route;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.sold,
    required this.imageUrl,
    this.description,
    this.specifications,
    this.route,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      price: json['price'] as int,
      oldPrice: json['old_price'] as int?,
      rating: (json['rating'] as num).toDouble(),
      sold: json['sold'] as int,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String?,
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'sold': sold,
      'image_url': imageUrl,
      'description': description,
      'specifications': specifications,
      'route': route,
    };
  }
}