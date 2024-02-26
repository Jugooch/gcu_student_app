import 'dart:convert';
import 'package:flutter/services.dart';

import '../services.dart';

class MarketService {
  // Fetches the list of businesses from a JSON file or database
  Future<List<Business>> getBusinesses() async {
    final String response = await rootBundle.loadString('assets/data/market-businesses-data.json');
    final data = await json.decode(response);
    return (data as List).map((i) => Business.fromJson(i)).toList();
  }

    // Fetches the list of businesses from a JSON file or database
  Future<List<Business>> getUserBusinesses(User user) async {
    final String response = await rootBundle.loadString('assets/data/market-businesses-data.json');
    final data = await json.decode(response);
    return (data as List).map((i) => Business.fromJson(i)).where((element) => element.ownerId == user.id).toList();
  }

  // Fetches the products for a specific business
  Future<List<Product>> getProducts(int businessId) async {
    final String response = await rootBundle.loadString('assets/data/market-products-data.json');
    final data = await json.decode(response);
    List<Product> products = (data as List)
        .map((i) => Product.fromJson(i))
        .where((product) => product.businessId == businessId)
        .toList();
    return products;
  }
}

class Business {
  final String name;
  final String description;
  final String image;
  final String ownerId;
  final List<String> categories;

  Business({
    required this.name,
    required this.description,
    required this.image,
    required this.ownerId,
    required this.categories,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      ownerId: json['ownerId'],
      categories: List<String>.from(json['categories']),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String description;
  final int businessId;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.businessId,
    required this.category
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      businessId: json['businessId'],
      category: json['category']
    );
  }
}
